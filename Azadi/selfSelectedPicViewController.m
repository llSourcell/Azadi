//
//  selfSelectedPicViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/28/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "selfSelectedPicViewController.h"

@interface selfSelectedPicViewController ()

@end

@implementation selfSelectedPicViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selfphotoSelected" forIndexPath:indexPath];
    
    //Add Username
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username_self"];
    UILabel *username_label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 30)];
    username_label.text = username;
    NSLog(@"I got it %@", username);
    [cell.contentView addSubview:username_label];
    
    //Add Profile Pic
    NSData *profilePicData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profilepic_self"];
    UIImage *profileImage = [UIImage imageWithData:profilePicData];
    UIImageView *profileCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 99, 99)];
    profileCell.image = profileImage;
    [cell.contentView addSubview:profileCell];
    
    
    //Add Time Stamp
    NSDate *timestamp_raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp_self"];
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:timestamp_raw
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    UILabel *timestamp_label = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 250, 30)];
    timestamp_label.text = timestamp;
    [cell.contentView addSubview:timestamp_label];
    
    
    //Add Selected Pic
    NSData *photoTouchedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoTouched_self"];
    UIImage *photoTouched = [UIImage imageWithData:photoTouchedData];
    UIImageView *photoCell = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 220, 250)];
    photoCell.image = photoTouched;
    [cell.contentView addSubview:photoCell];
    
    
    /*
    //Add like Button
    UIButton *likebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [likebutton addTarget:self
                   action:@selector(likeButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [likebutton setTitle:@"Like" forState:UIControlStateNormal];
    likebutton.frame = CGRectMake(100.0, 55.0, 100.0, 40.0);
    likebutton.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:likebutton];
    
    
    //Add follow Button
    UIButton *followbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [followbutton addTarget:self
                     action:@selector(followButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [followbutton setTitle:@"Follow" forState:UIControlStateNormal];
    followbutton.frame = CGRectMake(200.0, 55.0, 100.0, 40.0);
    followbutton.backgroundColor = [UIColor purpleColor];
    [cell.contentView addSubview:followbutton];
    
    */
    return cell;
    
}




@end
