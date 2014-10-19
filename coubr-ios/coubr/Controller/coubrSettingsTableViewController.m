//
//  coubrSettingsTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrSettingsTableViewController.h"
#import "coubrConstants.h"

@interface coubrSettingsTableViewController ()

@end

@implementation coubrSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else {
        return 0;
    }
    
    
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    
//    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
//    
//    [headerView.textLabel setTintColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
//    [headerView.textLabel setTextColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
//    [headerView.textLabel setFont:[UIFont fontWithName:@"Raleway-Light" size:14.0]]; //iOS 8 Bug
//    
//}

#define HEADER_TOP_SPACE 16.0
#define HEADER_LEADING_SPACE 16.0
#define HEADER_FONT_SIZE 14.0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *headerLabel = [[UILabel alloc] init];
    
    [headerLabel setFont:[UIFont fontWithName:@"Raleway-Light" size:HEADER_FONT_SIZE]];
    [headerLabel setTintColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
    [headerLabel setText:[self tableView:tableView titleForHeaderInSection:section]];
    [headerLabel setFrame:(CGRectMake(HEADER_LEADING_SPACE, HEADER_TOP_SPACE, 200, HEADER_FONT_SIZE))];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_TOP_SPACE + HEADER_TOP_SPACE + HEADER_FONT_SIZE;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)openAppStore:(id)sender {

    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_LINK]]) {

    }
    
}

- (IBAction)openFacebook:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:FACEBOOK_APP_LINK]]) {
        
        // Open Safari
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:FACEBOOK_LINK]]) {
            
        }
    }
    
}

- (IBAction)openTwitter:(id)sender {
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_APP_LINK]]) {
        
        // Open Safaro
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_LINK]]) {

        }
    }
    
}

@end
