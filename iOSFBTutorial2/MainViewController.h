//
//  MainViewController.h
//  iOSFBTutorial2
//
//  Created by Matthew Liu on 6/17/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ShareViewController.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *authButton;

- (IBAction)authButtonAction:(id)sender;

@end
