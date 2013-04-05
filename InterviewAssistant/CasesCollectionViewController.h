//
//  CasesCollectionViewController.h
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableData *responseData;
NSURLConnection *conn;

@interface CasesCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *casesCollection;

@end
