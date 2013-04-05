//
//  CaseDetailsViewController.h
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableData *responseData;
NSURLConnection *conn;

@interface CaseDetailsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

@property (weak, nonatomic) NSString *caseDetailsURL;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitleBar;
@property (weak, nonatomic) IBOutlet UITableView *caseDetailsTable;

@end
