//
//  LoginViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

AppDelegate *appDelegate;



@interface LoginViewController ()

@property (strong, nonatomic) NSArray *nameArray;
@property (strong, nonatomic) NSArray *idArray;

@end

@implementation LoginViewController

@synthesize facebookLoginButton, usernametoparse, profilepictoparse, loggedinUser;

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
    
    // Do any additional setup after loading the view.
    [self updateView];
    appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
    
 
}

- (void)updateView
{
    // get the app delegate, so that we can reference the session property
    appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        [self parseValues];
    }

}
- (void)parseValues
{
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@", appDelegate.session.accessTokenData.accessToken];
    NSLog(@"%@ ::::", urlString);
    NSURL *url1 = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request1 setHTTPMethod: @"GET"];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest: request1 returningResponse: &response error: nil];
    NSError *error = [[NSError alloc] init];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    
    if ([response statusCode] >=200 && [response statusCode] <300)
    {
        NSString *jsonString = [NSString stringWithContentsOfURL:url1 encoding:NSASCIIStringEncoding error:&error];
        NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
        
        if (jsonData == nil)
        {
            NSLog(@"Error in fetching data");
        }
        else
        {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
            //NSLog(@"jsonDictionary = %@", jsonDictionary);
            self.nameArray = [[jsonDictionary valueForKey:@"data"] valueForKey:@"name"];
            self.idArray = [[jsonDictionary valueForKey:@"data"] valueForKey:@"id"];
        }
    }
}


- (IBAction)facebookLoginTapped:(UIButton *)sender
{
    // get the app delegate so that we can access the session property
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen)
    {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
    }
    else
    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             // and here we make sure to update our UX according to the new session state
             [self updateView];
         }];
    }

}

-(void) viewDidAppear:(BOOL)animated
{
    //If the user is logged in,
    if(appDelegate.session.isOpen)
    {
        NSLog(@"Logged in");
        
      //Get user's full name and profile pic. and birthday.
        __block NSString *username; //username
        __block NSData *data;
        __block UIImage *image;
        __block NSData * imageData; //profile pic
        __block NSString *birthday; //birthday
        [FBSession setActiveSession:appDelegate.session];
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             NSLog(@"yo its my name %@",user.name);
             birthday = user.birthday;
             username = user.name;
             
            //save username and PFUser to global userdefaults for app useage
             NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
             usernametoparse = username;
             [[NSUserDefaults standardUserDefaults]
              setObject:usernametoparse forKey:@"User"];
             [standardUserDefaults synchronize];
             
             
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.id]];
             data = [NSData dataWithContentsOfURL:url];
             image = [[UIImage alloc] initWithData:data];
             imageData = UIImagePNGRepresentation(image);
             profilepictoparse = imageData;
             if(!error)
             {
                 NSLog(@"no error");
                 [self parseSignup];
             
             }

         }];
        
   
      
     //Push to the tab bar main view
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController * initialVC = [storyboard instantiateInitialViewController];
        [self presentViewController:initialVC animated:YES completion:nil];
    }
    else //do nothing, let the user login.
    {
        
        NSLog(@"Not Logged in");
    }
    
   
    
}

- (void) parseSignup
{
    //Save username + pic to Parse
    PFUser *user = [PFUser user];
    user.username = usernametoparse;
    user.password = @"xxx";
    PFFile *imageFile = [PFFile fileWithName:@"profilepic" data:profilepictoparse];

    
    
    PFObject *photos = [PFObject objectWithClassName:@"Photos"];
    photos[@"profile_pic"] =imageFile;
    photos[@"user"] = user;
    photos[@"my_username"] = user.username;
    
    
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            NSLog(@"Success");
            //Save profile pic to parse
            [photos saveInBackground];
            
        }
        else {

            NSLog(@"Failure");

        }
        
    }];
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
