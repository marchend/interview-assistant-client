//
//  CaseCell.h
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

@end
