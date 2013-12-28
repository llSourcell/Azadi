//
//  FourthViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "ProfilePicsView.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize username, profilePic, myPhotos, photoCollectionView;

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
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [self showUsernameandPassword];
    [self pullUserPhotos];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//DATA SOURCE Implementation

//Number of sections in collection
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    NSLog(@"how many sections?");

    return 1;
}

//Number of items in section
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"how many items?!");
    
    return [myPhotos count];
}

//What's in each item?
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    

    UIImageView *precellImage = [[UIImageView alloc] init];
    precellImage.image = [myPhotos objectAtIndex:indexPath.row];
    NSLog(@"collection view loading image called %@", [myPhotos objectAtIndex:indexPath.row]);
    
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:6];
    cellImage.image = precellImage.image;
    [cell addSubview:cellImage];
    return cell;
}


-(void) pullUserPhotos
{

    myPhotos = [[NSMutableArray alloc] init];

    //Username is pulled
    PFUser *curr_user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Main_Photos"];
    [query whereKey:@"User" equalTo:curr_user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %d main_photo objects for the user.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object ids %@", object.objectId);
                PFFile *imagefile = object[@"snapped_pics"];
                [imagefile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        //Get each image and put it into an array
                        UIImage *image = [UIImage imageWithData:imageData];
                        NSLog(@"the image data %@", image);
                        [myPhotos addObject:image];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [self.photoCollectionView reloadData];
                        });

                    }
                }];

            }
            
    

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
        
        

        
    

    
}


-(void) showUsernameandPassword
{
    //Getting username
    __block NSString *the_username;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user_test = [prefs stringForKey:@"User"];
    NSLog(@"username is %@",user_test);
    
    __block NSString *userid;
    //Query the user class
    PFQuery *query= [PFUser query];
    [query whereKey:@"username" equalTo:user_test];
    
    //get object from user class with username = your username
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        //sets username string from PFObject
        the_username = object[@"username"];
        //set UILabel Username
        userid = object.objectId;
        username.text = the_username;
        if(!error)
        {
            dispatch_queue_t myBackgroundQueue;
            myBackgroundQueue = dispatch_queue_create("get profile pic", NULL);
            
            dispatch_async(myBackgroundQueue, ^(void) {
                
                //get the row from the photos class that corresponds with the user
                PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
                NSLog(@"right before i send it %@", userid);
                PFUser *user = [PFUser currentUser];
                NSLog(@"the user info is %@", user);
                
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // Do something with the found objects
                        for (PFObject *object in objects) {
                            NSLog(@"%@", object.objectId);
                            PFFile *profile_pic = object[@"profile_pic"];
                            [profile_pic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                                if (!error)
                                {
                                    //sets profile pic
                                    UIImage *image = [UIImage imageWithData:imageData];
                                    profilePic.image = image;
                                }
                            }];
                        }
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
                
                
            });
        }
        
        
        
    }];
    
    
    
    

}

@end
