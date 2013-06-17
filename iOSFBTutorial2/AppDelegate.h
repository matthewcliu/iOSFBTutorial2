//
//  AppDelegate.h
//  iOSFBTutorial2
//
//  Created by Matthew Liu on 6/17/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;


@end
