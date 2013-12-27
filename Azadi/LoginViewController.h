//
//  LoginViewController.h
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>




@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@property (strong, nonatomic) NSString *usernametoparse;
@property (strong, nonatomic) NSData *profilepictoparse;


@property (strong, nonatomic) PFUser *loggedinUser;

- (IBAction)facebookLoginTapped:(UIButton *)sender;


@end
