//
//  CommentViewController.m
//  Azadi
//
//  Created by Jason Ravel on 12/29/13.
//  Copyright (c) 2013 Jason Ravel. All rights reserved.
//

#import "CommentViewController.h"
#import <Parse/Parse.h>


@interface CommentViewController ()

@end

@implementation CommentViewController

@synthesize commentInput, allComments, theTable, profilePics, allCommenters, timeStamps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    commentInput.delegate = self;

}

- (void) viewDidAppear:(BOOL)animated
{
    [self pullAllComments];
    NSLog(@"TEST");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *test = @"row";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:test];
    
    //add comments
    cell.detailTextLabel.text = [allComments objectAtIndex:indexPath.row];
    
    //add usernames
    cell.textLabel.text = [allCommenters objectAtIndex:indexPath.row];
    
    //add timestamps
    UILabel *time_label = [[UILabel alloc] init];
    time_label.frame = CGRectMake(225, 0, 60, 20);
    NSString *timestamp = [NSDateFormatter localizedStringFromDate:[timeStamps objectAtIndex:indexPath.row]
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    time_label.text = timestamp;
    time_label.font = [time_label.font fontWithSize:10];
    [cell addSubview:time_label];
    
    //add profile pics
    PFFile *getFile = [profilePics objectAtIndex:indexPath.row];
    NSData *photoData = [getFile getData];
    UIImage *image = [UIImage imageWithData:photoData];
    UIImageView *profile_view = [[UIImageView alloc] initWithImage:image];
    profile_view.frame = CGRectMake(100,0,60,60);
    [cell addSubview:profile_view];
    
    return cell;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.frame=CGRectMake(0, -220, 320, 700);
    
}

//whenever user pressed return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    commentInput.text = textField.text;
    [self sendCommentToParse];
    
    return NO;
}

- (void) sendCommentToParse
{
    PFUser *currentUser = [PFUser currentUser];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString *username = currentUser.username;
    NSString *comment = commentInput.text;
    
    NSData *profile_pic =  [standardUserDefaults objectForKey:@"profilepic_explore"];
    PFFile *profile_pic_file = [PFFile fileWithName:@"profile_pic.png" data:profile_pic];
    
    NSString *photo_ID =  [standardUserDefaults objectForKey:@"objectid_explore"];

    PFObject *commentClass = [PFObject objectWithClassName:@"Comments"];
    commentClass[@"username"] = username;
    commentClass[@"comment"] = comment;
    commentClass[@"profile_pic"] = profile_pic_file;
    commentClass[@"photo_ID"] = photo_ID;
    [commentClass saveInBackground];
    
    //push textview back down
    self.view.frame=CGRectMake(0, 0, 320, 700);

    //Refresh tableview last TODO
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.theTable reloadData];
    });

}

- (void) pullAllComments
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *photo_ID =  [standardUserDefaults objectForKey:@"objectid_explore"];
    
    
    allComments = [[NSMutableArray alloc] init];
    allCommenters = [[NSMutableArray alloc] init];
    timeStamps = [[NSMutableArray alloc] init];
    profilePics = [[NSMutableArray alloc] init];

    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query whereKey:@"photo_ID" equalTo:photo_ID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object);
                
                [allComments addObject:object[@"comment"]];
                [allCommenters addObject:object[@"username"]];
                [timeStamps addObject:object.createdAt];
               [profilePics addObject:object[@"profile_pic"]];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self.theTable reloadData];
                });
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
   
    
}


@end
