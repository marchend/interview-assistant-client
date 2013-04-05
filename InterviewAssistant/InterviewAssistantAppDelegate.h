//
//  InterviewAssistantAppDelegate.h
//  InterviewAssistant
//
//  Created by Marc Henderson on 2013-04-05.
//  Copyright (c) 2013 Marc Henderson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BASE_URL      @"http://192.168.36.139:3000"

@interface InterviewAssistantAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) NSDictionary *loginCred;

@end
