//
//  coubrStoreOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreOverviewController.h"

#import <CoreData/CoreData.h>


#import "Store+CRUD.h"
#import "coubrDatabaseManager.h"
#import "coubrCouponTableViewCell.h"
#import "coubrLocale.h"


@interface coubrStoreOverviewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;

@end

@implementation coubrStoreOverviewController



#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    [context performBlockAndWait:^{
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:[Store fetchRequestForStoreWithId:self.parentController.parentController.storeId] error:&error];
        
        if (results > 0) {
            Store *store = (Store *) [results firstObject];
            
            [self initWithStore:store];
            
        }
        
    }];
    
}

- (void)initWithStore:(Store *)store
{
    [self.streetLabel setText:store.street];
    [self.cityLabel setText:[NSString stringWithFormat:@"%@ %@", store.postalCode, store.city]];
    [self.phoneButton setTitle: store.phone ? store.phone : LOCALE_STORE_NO_PHONE forState:UIControlStateNormal];
    [self.emailButton setTitle: store.email ? store.email : LOCALE_STORE_NO_EMAIL forState:UIControlStateNormal];
    
    [self setEmail:store.email ? store.email : nil];
    [self setPhone:store.phone ? store.phone : nil];

    if (!store.phone) {
        self.phoneButton.enabled = NO;
    }
    
    if (!store.email) {
        self.emailButton.enabled = NO;
    }

    [self.descriptionTextView setText: store.storeDescription? store.storeDescription : LOCALE_STORE_NO_DESCRIPTION];
}

- (IBAction)sendEmail:(id)sender {
    
    if (self.email) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[ self.email ]];
        
        mailController.mailComposeDelegate = self;

        if ([MFMailComposeViewController canSendMail]){
            [self.parentController.parentController.navigationController presentViewController:mailController animated:YES completion:nil];
        }

    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
        
 
        
    }];
}
    
- (IBAction)call:(id)sender {
    
    if (self.phone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.phone]]];
    }
    
}

@end
