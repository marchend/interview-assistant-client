//
//  CasesCollectionViewController.m
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "CasesCollectionViewController.h"
#import "CaseCell.h"
#import "InterviewAssistantAppDelegate.h"
#import "CaseDetailsViewController.h"

@interface CasesCollectionViewController ()
{
    NSArray *arrayOfCases;
}
- (void)loadData;
@end

@implementation CasesCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.casesCollection setDataSource:self];
    [self.casesCollection setDelegate:self];
    
    //TEMP DATA
//    arrayOfCases = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    
	//CALL To Get Real Data
    [self loadData];
}

- (void)loadData{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/cases",BASE_URL]];
    NSMutableURLRequest *loginGET = [NSMutableURLRequest requestWithURL:url];

    //if login is successful we need this dictionary for future requests
    InterviewAssistantAppDelegate *del = (InterviewAssistantAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [loginGET setAllHTTPHeaderFields:del.loginCred];
    [loginGET setHTTPMethod:@"GET"];
    
    conn = [[NSURLConnection alloc] initWithRequest:loginGET delegate:self];
    [conn start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Datasource Delegate Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [arrayOfCases count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *celIdentifier = @"Cell";
    CaseCell *cell = [cv dequeueReusableCellWithReuseIdentifier:celIdentifier forIndexPath:indexPath];
    
    NSDictionary *currentCase = (NSDictionary *)[arrayOfCases objectAtIndex:indexPath.row];
    
    NSNumber *vidCount = (NSNumber *)[currentCase objectForKey:@"videoCount"];
    NSNumber *noteCount = (NSNumber *)[currentCase objectForKey:@"noteCount"];
    NSNumber *picCount = (NSNumber *)[currentCase objectForKey:@"photoCount"];
    
    cell.videoCountLabel.text = [NSString stringWithFormat:@"Videos:%d",[vidCount intValue]];
    cell.photosCountLabel.text = [NSString stringWithFormat:@"Photos:%d",[picCount intValue]];
    cell.notesCountLabel.text = [NSString stringWithFormat:@"Notes:%d",[noteCount intValue]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"caseDetailsSegue"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        CaseDetailsViewController *detailsViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        NSDictionary *currentCase = (NSDictionary *)[arrayOfCases objectAtIndex:indexPath.row];
        detailsViewController.caseDetailsURL = (NSString *)[currentCase objectForKey:@"inteviewsURL"];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - NSURLConnection Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    NSLog(@"we received an item click for a case...");
}

#pragma mark - NSURLConnection Datasource Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"we had an error:%@",error.description);
    //do something to deal with error
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    NSString *txt = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
    NSLog(@"Our Response is:%@",txt);
    
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"we got a responseDic for call to get the cases:%@",responseDic);
    arrayOfCases = (NSArray *)[responseDic objectForKey:@"cases"];
    NSLog(@"array of cases loaded now... what do I call to display cases?");
    [self.casesCollection reloadData];
}

@end
