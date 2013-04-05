//
//  CaseDetailsViewController.m
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "CaseDetailsViewController.h"
#import "InterviewAssistantAppDelegate.h"

@interface CaseDetailsViewController ()
{
    NSDictionary *caseDetails;
    NSArray *arrayOfPhotos;
    NSArray *arrayOfVideos;
    NSArray *arrayOfNotes;
}

@end

@implementation CaseDetailsViewController

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
	// Do any additional setup after loading the view.
    NSLog(@"our case URL is:%@",self.caseDetailsURL);
    [self loadData];
    [self.caseDetailsTable setDataSource:self];
    [self.caseDetailsTable setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,self.caseDetailsURL]];
    NSMutableURLRequest *interviewsGet = [NSMutableURLRequest requestWithURL:url];
    
    //if login is successful we need this dictionary for future requests
    InterviewAssistantAppDelegate *del = (InterviewAssistantAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [interviewsGet setAllHTTPHeaderFields:del.loginCred];
    [interviewsGet setHTTPMethod:@"GET"];
    
    conn = [[NSURLConnection alloc] initWithRequest:interviewsGet delegate:self];
    [conn start];
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
    NSLog(@"Our interviews Response is:%@",txt);
    
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"we got a responseDic for call to get the cases:%@",responseDic);
    caseDetails = (NSDictionary *)[responseDic objectForKey:@"caseDetails"];
    self.navTitleBar.title = [caseDetails objectForKey:@"name"];
    arrayOfNotes = (NSArray *)[responseDic objectForKey:@"notes"];
    arrayOfPhotos = (NSArray *)[responseDic objectForKey:@"photos"];
    arrayOfVideos = (NSArray *)[responseDic objectForKey:@"videos"];
    [self.caseDetailsTable reloadData];
}


- (IBAction)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Datasource Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return [arrayOfPhotos count];
    }else if(section == 1){
        return [arrayOfVideos count];
    }else{
        return [arrayOfNotes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textLabel.text = [arrayOfNotes objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    BATTrailsViewController *trailsController = [[BATTrailsViewController alloc] initWithStyle:UITableViewStylePlain];
//    trailsController.selectedRegion = [regions objectAtIndex:indexPath.row];
//    [[self navigationController] pushViewController:trailsController animated:YES];
//    [trailsController release];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"caseDetailsSegue"]) {
//        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
//        CaseDetailsViewController *detailsViewController = segue.destinationViewController;
//        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
//        NSDictionary *currentCase = (NSDictionary *)[arrayOfCases objectAtIndex:indexPath.row];
//        detailsViewController.caseDetailsURL = (NSString *)[currentCase objectForKey:@"inteviewsURL"];
//        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    }
}

@end
