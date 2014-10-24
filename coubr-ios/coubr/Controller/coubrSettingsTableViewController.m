//
//  coubrSettingsTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrSettingsTableViewController.h"
#import "coubrConstants.h"
#import "coubrLocale.h"

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
        // general
        return 1;
    } else if (section == 1) {
        // support
        return 2;
    } else if (section == 2) {
        // about
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

#define HEADER_IDENTIFIER @"SettingsHeaderReuseIdentifier"

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *) view;
    
    [headerView.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]];
    [headerView.textLabel setTintColor:[UIColor colorWithRed:51 green:51 blue:51 alpha:1]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // general
        
        
    } else if (indexPath.section == 1) {
        // support
        if (indexPath.row == 1) {
            // feedback
            
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setToRecipients:@[ FEEDBACK_EMAIL ]];
            [mailController setSubject:LOCALE_FEEDBACK_SUBJECT];
            mailController.mailComposeDelegate = self;
            
            if ([MFMailComposeViewController canSendMail]){
                [self.navigationController presentViewController:mailController animated:YES completion:nil];
            }
        }

    } else if(indexPath.section == 2) {
        // about
        
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - Message Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}


/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)openAppStore:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_LINK]];
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
