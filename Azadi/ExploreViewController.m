//
//  SecondViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "ExploreViewController.h"
#import <Parse/Parse.h>


@interface ExploreViewController ()

@end

@implementation ExploreViewController

@synthesize allPhotos, photoObjects;

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self pullAllPhotos];
 
}

//DATA SOURCE Implementation

//Number of sections in collection
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

//Number of items in section
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"how many items?! %lu", (unsigned long)[allPhotos count]);
    
    return [allPhotos count];
}

//What's in each item?
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"explore" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *precellImage = [[UIImageView alloc] init];
    precellImage.image = [allPhotos objectAtIndex:indexPath.row];  //Picture selected

    
   
    
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    cellImage.image = precellImage.image;
    [cell addSubview:cellImage];
    return cell;
}



-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    //Main_Photos object. Extract all info.
    PFObject *selectedPhoto =  [photoObjects objectAtIndex:indexPath.row];
    PFFile *photoFile = selectedPhoto[@"snapped_pics"];
    NSData *photoTouched = [photoFile getData]; //selected photo [1]
    NSDate *timestamp = [selectedPhoto updatedAt]; //TimeStamp [2]
    NSString *username = selectedPhoto[@"my_username"];  // Username [3]
    NSLog(@"username is %@", username);
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:photoTouched forKey:@"photoTouched_explore"];
        [standardUserDefaults setObject:timestamp forKey:@"timestamp_explore"];
        [standardUserDefaults setObject:username forKey:@"username_explore"];
        [standardUserDefaults synchronize];
    }
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photos"];
    [query whereKey:@"my_username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFFile *getFile = object[@"profile_pic"];
                NSData *profile_pic = [getFile getData]; // Profile_pic [4]
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                if (standardUserDefaults) {
                    [standardUserDefaults setObject:profile_pic forKey:@"profilepic_explore"];
                    [standardUserDefaults synchronize];
                }
                
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
   
    

    
    
    
    
    
    
    
    
}


-(void) pullAllPhotos
{
    
    allPhotos = [[NSMutableArray alloc] init];
    photoObjects = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Main_Photos"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object ids %@", object.objectId);
                
                PFFile *imagefile = object[@"snapped_pics"];
                [photoObjects addObject:object];
                [imagefile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        //Get each image and put it into an array
                        UIImage *image = [UIImage imageWithData:imageData];
                        NSLog(@"the image data %@", image);
                        [allPhotos addObject:image];
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [self.picsList reloadData];
                         
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



@end
