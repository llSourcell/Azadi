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

@synthesize allPhotos, photoObjects, searchBar, hashtagPhotos, userSearched, hashtagphotoObjects;

- (void)viewDidLoad
{
    [super viewDidLoad];
    searchBar.delegate =self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self pullAllPhotos];
    [self setUserSearched:NO];
 
}

//DATA SOURCE Implementation

//Number of sections in collection
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

//Number of items in section
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    
    int returnMe;
    if(userSearched == YES)
    {
        returnMe = [hashtagPhotos count];
    }
    else
    {
        returnMe = [allPhotos count];
    }
    
    return returnMe;
    
   
}

//What's in each item?
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"explore" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *precellImage = [[UIImageView alloc] init];
    if(userSearched == YES)
    {
     precellImage.image = [hashtagPhotos objectAtIndex:indexPath.row];
    }
    else
    {
    precellImage.image = [allPhotos objectAtIndex:indexPath.row];  //Picture selected
    }
   
    
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    cellImage.image = precellImage.image;
    [cell addSubview:cellImage];
    return cell;
        
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //When the user searches a hash tag, we search parse for all PFObjects with that hashtag and pull them into an array.
    
    userSearched = YES;

    hashtagPhotos = [[NSMutableArray alloc] init];
    hashtagphotoObjects = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Main_Photos"];
    [query whereKey:@"Hashtag" equalTo:searchBar.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects)
            {
                [hashtagphotoObjects addObject:object];
                PFFile *getFile = object[@"snapped_pics"];
                NSData *photoData = [getFile getData];
                UIImage *image = [UIImage imageWithData:photoData];
                [hashtagPhotos addObject:image];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.picsList reloadData];
                    
                });
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}




-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    //Main_Photos object. Extract all info.
    PFObject *selectedPhoto;
    if(userSearched == YES)
    {
        selectedPhoto =  [hashtagphotoObjects objectAtIndex:indexPath.row];

    }
    else
    {
        selectedPhoto =  [photoObjects objectAtIndex:indexPath.row];

    }
    PFFile *photoFile = selectedPhoto[@"snapped_pics"];
    NSData *photoTouched = [photoFile getData]; //selected photo [1]
    NSDate *timestamp = [selectedPhoto updatedAt]; //TimeStamp [2]
    NSString *username = selectedPhoto[@"my_username"];  // Username [3]
    NSLog(@"username is %@", username);
    NSString *objectid = selectedPhoto.objectId;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:photoTouched forKey:@"photoTouched_explore"];
        [standardUserDefaults setObject:timestamp forKey:@"timestamp_explore"];
        [standardUserDefaults setObject:username forKey:@"username_explore"];
        [standardUserDefaults setObject:objectid forKey:@"objectid_explore"];
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
