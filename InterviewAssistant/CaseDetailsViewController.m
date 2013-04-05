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
    
}


- (IBAction)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
