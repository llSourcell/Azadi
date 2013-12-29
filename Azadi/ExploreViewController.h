//
//  SecondViewController.h
//  Azadi
//
//  Created by Jason Ravel on 12/23/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate>

//UI Elements
@property (strong, nonatomic) IBOutlet UICollectionView *picsList;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


//Pre search
@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (strong, nonatomic) NSMutableArray *photoObjects;

//Post Search
@property (strong, nonatomic) NSMutableArray *hashtagPhotos;
@property (strong, nonatomic) NSMutableArray *hashtagphotoObjects;


//If the user searched a hashtag, reload the view with his new pics
@property (nonatomic, assign) BOOL userSearched;



@end
