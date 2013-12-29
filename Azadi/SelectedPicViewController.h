//
//  SelectedPicViewController.h
//  Azadi
//
//  Created by Jason Ravel on 12/26/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPicViewController : UITableViewController

- (IBAction)likeButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@end
