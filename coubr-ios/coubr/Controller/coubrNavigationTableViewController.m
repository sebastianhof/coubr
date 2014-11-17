//
//  coubrSettingsTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 18/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrNavigationTableViewController.h"
#import "coubrConstants.h"
#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrNavigationTableViewController ()

@end

@implementation coubrNavigationTableViewController

#pragma mark - Table view data source

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    [self blurBackground];
}

#pragma mark - Init

- (void)initTableView
{
    CGFloat topBarOffset = self.mainViewController.topLayoutGuide.length;
    [self.tableView setContentInset:UIEdgeInsetsMake(topBarOffset, 0, 0, 0)];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        // support
        return 2;
    } else if (section == 1) {
        // about
        return 2;
    } else {
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    [headerView.textLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
      
        if(indexPath.row == 1) {
            // feedback
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            [mailController setToRecipients:@[ FEEDBACK_EMAIL ]];
            [mailController setSubject:LOCALE_FEEDBACK_SUBJECT];
            mailController.mailComposeDelegate = self;
            
            if ([MFMailComposeViewController canSendMail]){
                [self.mainViewController.navigationController presentViewController:mailController animated:YES completion:nil];
            }
        } 
        
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - IBAction

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

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

- (IBAction)openTwitter:(id)sender
{
    
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_APP_LINK]]) {
        
        // Open Safari
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:TWITTER_LINK]]) {

        }
    }
}

#pragma mark - UIPanGestureRecognizer

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
    static CGPoint originalPoint;
    CGRect superviewFrame = self.view.frame;
    
    CGPoint translatedPoint = [sender translationInView:self.view];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        originalPoint = sender.view.center;
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (originalPoint.x < superviewFrame.size.width && translatedPoint.x < 0) {
            
            [self.view setFrame:CGRectMake(0 + translatedPoint.x, superviewFrame.origin.y, superviewFrame.size.width, superviewFrame.size.height)];

        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        
        
        if (superviewFrame.size.width + translatedPoint.x < (superviewFrame.size.width * 0.50)) {
            [self.view setFrame:CGRectMake(0 - superviewFrame.size.width, superviewFrame.origin.y, superviewFrame.size.width, superviewFrame.size.height)];
            [self.mainViewController removeNavigationViewInMainView];
        } else {
            [self.view setFrame:CGRectMake(0, superviewFrame.origin.y, superviewFrame.size.width, superviewFrame.size.height)];
        }
        
    }
    
}

#pragma mark - Blur

- (void)blurBackground{
    CGSize size = CGSizeMake(self.mainViewController.view.bounds.size.width * 0.7, self.mainViewController.view.bounds.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.mainViewController.view.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:viewImage]];
}


@end
