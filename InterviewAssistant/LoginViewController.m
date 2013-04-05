//
//  LoginViewController.m
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//BUTTON HANDLERS
- (IBAction)loginClicked:(id)sender {
    NSLog(@"loginClicked...");
    //do something here to
    
    NSString *loginCredentials = [NSString stringWithFormat:@"%@:%@",self.username.text,self.password.text];
    
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.36.139:3000/login"];
    NSMutableURLRequest *loginPost = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    [loginDict setValue:loginCredentials forKey:@"authorization"];
    [loginPost setAllHTTPHeaderFields:loginDict];
    [loginPost setHTTPMethod:@"POST"];
    
    conn = [[NSURLConnection alloc] initWithRequest:loginPost delegate:self];
    [conn start];
}

// NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"we had an error:%@",error.description);
    //do something to deal with error
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    NSString *txt = [[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding];
    NSLog(@"Our Response is:%@",txt);
    
    NSError *error = nil;
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    NSNumber *wasSuccess = (NSNumber *)[responseDic objectForKey:@"success"];
    
    if( [wasSuccess boolValue] ){
        [self performSegueWithIdentifier:@"goCases" sender:self];        
    }else{
        //do something to display error
    }
    
    
}

@end
