//
//  ProfilePicsView.m
//  Azadi
//
//  Created by Jason Ravel on 12/26/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "ProfilePicsView.h"


@implementation ProfilePicsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
      
    }
    return self;
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Touched!");
}

-(void) pullUserPics
{
    PFQuery *query = [PFQuery queryWithClassName:@"Main_Photos"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // If there are photos, we start extracting the data
        // Save a list of object IDs while extracting this data
        
        NSMutableArray *newObjectIDArray = [NSMutableArray array];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (objects.count > 0) {
            for (PFObject *eachObject in objects) {
                [newObjectIDArray addObject:[eachObject objectId]];
                NSLog(@"YO!!!! %@", eachObject);
            }
        }
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
