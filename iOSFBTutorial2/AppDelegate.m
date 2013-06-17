//
//  AppDelegate.m
//  iOSFBTutorial2
//
//  Created by Matthew Liu on 6/17/13.
//  Copyright (c) 2013 Matthew Liu. All rights reserved.
//

#import "AppDelegate.h"

NSString *const FBSessionStateChangedNotification = @"com.unicyclelabs.iOSFBTutorial2:FBSessionStateChangedNotification";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    MainViewController *mVC = [[MainViewController alloc] init];
    [[self window] setRootViewController:mVC];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[FBSession activeSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];
}

//Adding methods to allow for FB authentication

//Login UI and callback to session notification - this will follow the waterfall to pick the best authentication methods

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    //Create an array of permissions we want
    NSArray *permissions = [NSArray arrayWithObjects:@"basic_info", @"email",@"user_likes" nil];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI: allowLoginUI completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}


//Session state change notification method
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                //Do something here
                NSLog(@"User session open");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [[FBSession activeSession] closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    //Post notification to NSNotificationCenter
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];

    //Error notifications
    if (error){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

//FB method for handling old authentication methods for users that don't have iOS 6+ - handler for redirect URLs
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSession activeSession] handleOpenURL:url];
}

@end
