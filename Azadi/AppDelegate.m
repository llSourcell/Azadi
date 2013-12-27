//
//  AppDelegate.m
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

-(void) showLogin
{
    //Present Login screen on app startup
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = lvc;
    [self.window makeKeyAndVisible];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Connect to Parse
    [Parse setApplicationId:@"dTYlFoofZ7676ic1NtV2MSxRChl5N6onfDQR0IY4"
                  clientKey:@"EGSXwu4oJBgdeScvsdbN0b50J3wfexDujGrkLoSf"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //Show login view controller
    [self showLogin];
    
    
    //Open Facebook Session
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
 
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];

}

//For faceBook login
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
}

@end
