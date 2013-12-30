//
//  CommentViewController.h
//  Azadi
//
//  Created by Jason Ravel on 12/29/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *commentInput;


@property (strong, nonatomic) NSMutableArray *allComments;
@property (strong, nonatomic) NSMutableArray *allCommenters;
@property (strong, nonatomic) NSMutableArray *profilePics;
@property (strong, nonatomic) NSMutableArray *timeStamps;



@property (strong, nonatomic) IBOutlet UITableView *theTable;

@end
