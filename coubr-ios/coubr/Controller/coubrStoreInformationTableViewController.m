//
//  coubrStoreInformationTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreInformationTableViewController.h"

#import <CoreData/CoreData.h>

#import "UIImage+ImageEffects.h"

#import "Store+CRUD.h"
#import "coubrDatabaseManager.h"
#import "coubrCouponTableViewCell.h"
#import "coubrLocale.h"

#import "coubrStoreAddressTableViewCell.h"
#import "coubrStoreDescriptionTableViewCell.h"
#import "coubrStoreContactTableViewCell.h"

@interface coubrStoreInformationTableViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) NSMutableDictionary *storeDictionary;
@property (nonatomic) int numbersOfSection;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrStoreInformationTableViewController

#pragma mark - init

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_notInit) {
       [self blurTableViewBackground];
    }
    
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
    self.numbersOfSection = 0;
    
    self.storeDictionary = [[NSMutableDictionary alloc] init];
    
    [self.storeDictionary setObject:@{ @"street" : store.street,
                                       @"postalCode": store.postalCode,
                                       @"city": store.city
                                       
                                       } forKey:@"address"];
    
    if (store.email || store.phone) {
        
        NSMutableDictionary *contactDict = [[NSMutableDictionary alloc] init];
        
        if (store.email) {
            [contactDict setObject:store.email forKey:@"email"];
        }
        
        if (store.phone) {
            [contactDict setObject:store.phone forKey:@"phone"];
        }
        
        [self.storeDictionary setObject:contactDict forKey:@"contact"];
        
    }
    
    if (store.storeDescription && store.storeDescription.length > 0) {
        
        [self.storeDictionary setObject:store.storeDescription forKey:@"description"];
        
    }

    [self.tableView reloadData];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (self.storeDictionary) {
        return [self.storeDictionary count];
    } else {
        return 0;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.storeDictionary) {
        if (section == 0) {
            return 2;
        }
        if (section == 1) {
            if ([self.storeDictionary objectForKey:@"contact"]) {
                return ((NSMutableDictionary *) [self.storeDictionary objectForKey:@"contact"]).count;
            } else if ([self.storeDictionary objectForKey:@"description"]) {
                return 1;
            }
        }
        if (section == 2) {
            if ([self.storeDictionary objectForKey:@"description"]) {
                return 1;
            }
        }
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.storeDictionary) {
        if (section == 0) {
            return LOCALE_STORE_ADDRESS;
        }
        if (section == 1) {
            if ([self.storeDictionary objectForKey:@"contact"]) {
                return LOCALE_STORE_CONTACT;
            } else if ([self.storeDictionary objectForKey:@"description"]) {
                return LOCALE_STORE_DESCRIPTION;
            }
        }
        if (section == 2) {
            if ([self.storeDictionary objectForKey:@"description"]) {
                return LOCALE_STORE_DESCRIPTION;
            }
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        // address
        if (indexPath.row == 0) {
            return [self initializeStreetTableViewCell];
        } else if (indexPath.row == 1 ) {
            return [self initializeCityTableViewCell];
        }
        
    } else if (indexPath.section == 1) {
        // contact or description
        
        if ([self.storeDictionary objectForKey:@"contact"]) {
            // contact
            NSMutableDictionary *contactDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"contact"];
                
            if (indexPath.row == 0) {
                    
                if ([contactDict objectForKey:@"phone"]) {
                    return [self initializePhoneTableViewCell];
                } else {
                    
                    if ([contactDict objectForKey:@"email"]) {
                        return [self initializeEmailTableViewCell];

                    }
                    
                }

            }
            
            if (indexPath.row == 1) {
                
                if ([contactDict objectForKey:@"email"]) {
                    return [self initializeEmailTableViewCell];
                    
                }
                
            }
            
            
        } else if ([self.storeDictionary objectForKey:@"description"]) {
            return [self initializeDescriptionTableViewCell];

        }
        
    } else if (indexPath.section == 2) {
        // description
        
        if ([self.storeDictionary objectForKey:@"description"]) {
            return [self initializeDescriptionTableViewCell];
        }
        
    }
    
    return nil;
    
}

- (UITableViewCell *)initializeStreetTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreAddressTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreAddressTableViewCell class]]) {
        
        NSMutableDictionary *addressDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"address"];
        
        coubrStoreAddressTableViewCell *addressCell = (coubrStoreAddressTableViewCell *)cell;
        [addressCell.label setText:[addressDict objectForKey:@"street"]];
        [addressCell.iconImageView setImage:[UIImage imageNamed:@"Store_Street"]];
        
    }
    return cell;
}

- (UITableViewCell *)initializeCityTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreAddressTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreAddressTableViewCell class]]) {
        
        NSMutableDictionary *addressDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"address"];
        
        coubrStoreAddressTableViewCell *addressCell = (coubrStoreAddressTableViewCell *)cell;
        [addressCell.label setText:[NSString stringWithFormat:@"%@ %@", [addressDict objectForKey:@"postalCode"], [addressDict objectForKey:@"city"]]];
        [addressCell.iconImageView setImage:[UIImage imageNamed:@"Store_City"]];
        
    }
    return cell;
}

- (UITableViewCell *)initializeEmailTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreContactTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreContactTableViewCell class]]) {

        NSMutableDictionary *contactDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"contact"];
        
        coubrStoreContactTableViewCell *contactCell = (coubrStoreContactTableViewCell *)cell;
        [contactCell.button setTitle:[contactDict objectForKey:@"email"] forState:UIControlStateNormal];
        [contactCell.button addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
        [contactCell.iconImageView setImage:[UIImage imageNamed:@"Store_Email"]];
    }
    return cell;
}

- (UITableViewCell *)initializePhoneTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreContactTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreContactTableViewCell class]]) {
        
        NSMutableDictionary *contactDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"contact"];
        
        coubrStoreContactTableViewCell *contactCell = (coubrStoreContactTableViewCell *)cell;
        [contactCell.button setTitle:[contactDict objectForKey:@"phone"] forState:UIControlStateNormal];
        [contactCell.button addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [contactCell.iconImageView setImage:[UIImage imageNamed:@"Store_Phone"]];
    }
    return cell;
}

- (UITableViewCell *)initializeDescriptionTableViewCell
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreDescriptionTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreDescriptionTableViewCell class]]) {

        [((coubrStoreDescriptionTableViewCell *)cell).descriptionTextView setText:[self.storeDictionary objectForKey:@"description"]];
    }
    return cell;
}


- (IBAction)sendEmail:(id)sender {
    
    NSMutableDictionary *contactDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"contact"];
    
    if (contactDict && [contactDict objectForKey:@"email"]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setToRecipients:@[ [contactDict objectForKey:@"email"] ]];
        
        mailController.mailComposeDelegate = self;

        if ([MFMailComposeViewController canSendMail]){
            [self.parentController.parentController.navigationController presentViewController:mailController animated:YES completion:nil];
        }

    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)call:(id)sender {
    
    NSMutableDictionary *contactDict = [(NSMutableDictionary *) self.storeDictionary objectForKey:@"contact"];
    
    if (contactDict && [contactDict objectForKey:@"phone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [contactDict objectForKey:@"phone"]]]];
    }
    
}

- (void)blurTableViewBackground
{
    UIGraphicsBeginImageContext(self.tableView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.view.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    self.notInit = YES;
}


@end
