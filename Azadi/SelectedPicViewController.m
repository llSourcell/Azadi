//
//  SelectedPicViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/26/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "SelectedPicViewController.h"
#import "ExploreViewController.h"
#import <Parse/Parse.h>


@interface SelectedPicViewController ()

@end

@implementation SelectedPicViewController

@synthesize likeButton;

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

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
  

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoSelected" forIndexPath:indexPath];
    
    //Add Username
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username_explore"];
    UILabel *username_label = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 30)];
    username_label.text = username;
    [cell.contentView addSubview:username_label];
  
    //Add Profile Pic
    NSData *profilePicData = [[NSUserDefaults standardUserDefaults] objectForKey:@"profilepic_explore"];
    UIImage *profileImage = [UIImage imageWithData:profilePicData];
    UIImageView *profileCell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 99, 99)];
    profileCell.image = profileImage;
    [cell.contentView addSubview:profileCell];
    
    
    //Add Time Stamp
    NSDate *timestamp_raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"timestamp_explore"];
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:timestamp_raw
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    UILabel *timestamp_label = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 250, 30)];
    timestamp_label.text = timestamp;
    [cell.contentView addSubview:timestamp_label];
    
    
    //Add Selected Pic
    NSData *photoTouchedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoTouched_explore"];
    UIImage *photoTouched = [UIImage imageWithData:photoTouchedData];
    UIImageView *photoCell = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 220, 250)];
    photoCell.image = photoTouched;
    [cell.contentView addSubview:photoCell];
    

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */



- (IBAction)likeButtonTapped:(UIButton *)sender
{
    //if the like button says "unlike" do nothing..
    PFUser *current = [PFUser currentUser];
    NSString *objectid = [[NSUserDefaults standardUserDefaults] objectForKey:@"objectid_explore"];
    
    //query your photos_ive_liked array to see if it contains the current photo object
    PFQuery *query = [PFUser query];
    [query whereKey:@"photos_ive_liked" containsAllObjectsInArray:@[objectid]];
    NSArray *object_array = [query findObjects];
    
    
    
    //if the user has already liked the photo
    if([object_array count] > 0)
    {
        NSLog(@"You've already liked this photo!");
    }
    else //if the user hasn't already liked the photo
    {
    
        //add this photo to your photos_ive_liked array
        [current addUniqueObjectsFromArray:@[objectid] forKey:@"photos_ive_liked"];
        [current saveInBackground];

        PFObject *photo_to_like = [PFObject objectWithoutDataWithClassName:@"Main_Photos" objectId:objectid];
    
        // Increment the current value of the quantity key by 1
        [photo_to_like incrementKey:@"Likes"];
    
        // Save
        [photo_to_like save];
        
        NSLog(@"You haven't liked this photo yet!");

    }
}
@end
