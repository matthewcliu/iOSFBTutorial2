//
//  MainViewController.m
//  iOSFBTutorial2
//
//  Created by Matthew Liu on 6/17/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *publishButton;
- (IBAction)publishButtonAction:(id)sender;

@end

@implementation MainViewController

@synthesize authButton;

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
    // Do any additional setup after loading the view from its nib.
    
    //Register for NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
    
    //Check if the user is already logged in from a cached session
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Method that refers to appDelegate and calls login method
- (IBAction)authButtonAction:(id)sender
{

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([[FBSession activeSession] isOpen]) {
        [appDelegate closeSession];
    } else {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}

//Method to handle FB session changes for this view
- (void)sessionStateChanged:(NSNotification *)notification
{
    if ([[FBSession activeSession] isOpen]) {
        [_publishButton setHidden:NO];
        [authButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [_publishButton setHidden:YES];
        [authButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (IBAction)publishButtonAction:(id)sender {
    ShareViewController *viewController = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
