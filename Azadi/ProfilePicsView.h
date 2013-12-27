//
//  ProfilePicsView.h
//  Azadi
//
//  Created by Jason Ravel on 12/26/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface ProfilePicsView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


-(void) pullUserPics;


@end
