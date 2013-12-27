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
    precellImage.image = [allPhotos objectAtIndex:indexPath.row];
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
    cellImage.image = precellImage.image;
    [cell addSubview:cellImage];
    return cell;
}

-(void) pullAllPhotos
{
    
    allPhotos = [[NSMutableArray alloc] init];
    photoObjects = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Main_Photos"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"object ids %@", object.objectId);
                PFFile *imagefile = object[@"snapped_pics"];
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
