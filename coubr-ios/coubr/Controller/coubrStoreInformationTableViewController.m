//
//  coubrStoreInformationTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreInformationTableViewController.h"
#import "coubrStoreViewController.h"

#import "coubrStoreAddressTableViewCell.h"
#import "coubrStoreDescriptionTableViewCell.h"
#import "coubrStoreContactTableViewCell.h"

#import "Store+CRUD.h"

#import "coubrLocale.h"

#import <CoreData/CoreData.h>
#import "UIImage+ImageEffects.h"
@interface coubrStoreInformationTableViewController ()

@property (weak, nonatomic) Store *store;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrStoreInformationTableViewController

#pragma mark - init

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {
        
        self.store = note.userInfo[STORE];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_notInit) {
       [self blurTableViewBackground];
    }
    
    if (self.store) {
        [self.tableView reloadData];
    }
    
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (self.store.storeDescription && (self.store.phone || self.store.email || self.store.website)) {
        return 3;
    } else if (self.store.storeDescription || (self.store.phone || self.store.email || self.store.website)) {
        return 2;
    } else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        
        if (self.store.storeDescription) {
            return 1;
        } else {
            return 1;
        }

    } else if (section == 1) {
        
        if (self.store.storeDescription) {
            return 1;
        } else {
            return [self numbersOfRowsInContactSection];
        }
        
    } else if (section == 2) {
        
        return [self numbersOfRowsInContactSection];
    
    }
    return 0;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (self.store.storeDescription) {
            return LOCALE_STORE_DESCRIPTION;
        } else {
            return LOCALE_STORE_ADDRESS;
        }
        
    } else if (section == 1) {
        
        if (self.store.storeDescription) {
            return LOCALE_STORE_ADDRESS;
        } else if (self.store.phone || self.store.email || self.store.website) {
            return LOCALE_STORE_CONTACT;
        }
        
    } else if (section == 2) {
        
        if (self.store.phone || self.store.email || self.store.website) {
            return LOCALE_STORE_CONTACT;
        }
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.store.storeDescription) {
            return [self initializeDescriptionTableViewCell];
        } else {
            return [self initializeAddressTableViewCell];
        }
        
    } else if (indexPath.section == 1) {
        
        if (self.store.storeDescription) {
            return [self initializeAddressTableViewCell];
        } else {
            return [self initializeCellsForContactSectionAtIndexPath:indexPath];
        }
        
    } else if (indexPath.section == 2) {
    
        return [self initializeCellsForContactSectionAtIndexPath:indexPath];
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (self.store.storeDescription) {
            return 44.0;
        } else {
            return 66.0;
        }
        
    } else if (indexPath.section == 1) {
        
        if (self.store.storeDescription) {
            return 66.0;
        } else {
            return 44.0;
        }
        
    } else if (indexPath.section == 2) {
        
        return 44.0;
        
    }

    return 44.0;
    
}

- (NSInteger)numbersOfRowsInContactSection
{
    
    if (self.store.phone && self.store.email && self.store.website) {
        return 3;
    } else if (self.store.phone && self.store.email) {
        return 2;
    } else if (self.store.email && self.store.website) {
        return 2;
    } else if (self.store.phone && self.store.website) {
        return 2;
    } else  if (self.store.phone) {
        return 1;
    } else if (self.store.email) {
        return 1;
    } else if (self.store.website) {
        return 1;
    } else {
        return 0;
    }
    
}

- (UITableViewCell *)initializeCellsForContactSectionAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.store.phone && self.store.email && self.store.website) {
        
        if (indexPath.row == 0) {
            return [self initializePhoneTableViewCell];
        } else if (indexPath.row == 1) {
            return [self initializeEmailTableViewCell];
        } else if (indexPath.row == 2) {
            return [self initializeWebsiteTableViewCell];
        }
        
    } else if (self.store.phone && self.store.email) {
        
        if (indexPath.row == 0) {
            return [self initializePhoneTableViewCell];
        } else if (indexPath.row == 1) {
            return [self initializeEmailTableViewCell];
        }
        
    } else if (self.store.email && self.store.website) {
        
        
        if (indexPath.row == 0) {
            return [self initializeEmailTableViewCell];
        } else if (indexPath.row == 1) {
            return [self initializeWebsiteTableViewCell];
        }
        
    } else if (self.store.phone && self.store.website) {
        
        
        if (indexPath.row == 0) {
            return [self initializePhoneTableViewCell];
        } else if (indexPath.row == 1) {
            return [self initializeWebsiteTableViewCell];
        }
        
    } else  if (self.store.phone) {
        
        return [self initializePhoneTableViewCell];
        
    } else if (self.store.email) {
        
        return [self initializeEmailTableViewCell];
        
    } else if (self.store.website) {
        
        return [self initializeWebsiteTableViewCell];
        
    }

    return nil;
}

- (UITableViewCell *)initializeAddressTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreAddressTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreAddressTableViewCell class]]) {
        coubrStoreAddressTableViewCell *addressCell = (coubrStoreAddressTableViewCell *)cell;
        [addressCell.streetLabel setText:self.store.street];
        [addressCell.cityLabel setText:[NSString stringWithFormat:@"%@ %@", self.store.postalCode, self.store.city]];
    }
    return cell;
}

- (UITableViewCell *)initializeEmailTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreContactTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreContactTableViewCell class]]) {
        coubrStoreContactTableViewCell *contactCell = (coubrStoreContactTableViewCell *)cell;
        [contactCell.button setTitle:self.store.email forState:UIControlStateNormal];
        [contactCell.button addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
        [contactCell.iconImageView setImage:[UIImage imageNamed:@"Store_Email"]];
    }
    return cell;
}

- (UITableViewCell *)initializePhoneTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreContactTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreContactTableViewCell class]]) {
        coubrStoreContactTableViewCell *contactCell = (coubrStoreContactTableViewCell *)cell;
        [contactCell.button setTitle:self.store.phone forState:UIControlStateNormal];
        [contactCell.button addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [contactCell.iconImageView setImage:[UIImage imageNamed:@"Store_Phone"]];
    }
    return cell;
}

- (UITableViewCell *)initializeWebsiteTableViewCell
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreContactTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreContactTableViewCell class]]) {
        coubrStoreContactTableViewCell *contactCell = (coubrStoreContactTableViewCell *)cell;
        [contactCell.button setTitle:self.store.website forState:UIControlStateNormal];
        [contactCell.button addTarget:self action:@selector(openWebsite:) forControlEvents:UIControlEventTouchUpInside];
        [contactCell.iconImageView setImage:[UIImage imageNamed:@"Store_Website"]];
    }
    return cell;
}

- (UITableViewCell *)initializeDescriptionTableViewCell
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"coubrStoreDescriptionTableViewCell"];
    if ([cell isKindOfClass:[coubrStoreDescriptionTableViewCell class]]) {

        [((coubrStoreDescriptionTableViewCell *)cell).descriptionTextView setText:self.store.storeDescription];
    }
    return cell;
}

- (void)call:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.store.phone]]];
}

- (void)sendEmail:(id)sender {

    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setToRecipients:@[ self.store.email ]];
    
    mailController.mailComposeDelegate = self;

    if ([MFMailComposeViewController canSendMail]){
        [self.navigationController presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)openWebsite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.store.website]];
}

#pragma mark - Blur

- (void)blurTableViewBackground
{
    UIGraphicsBeginImageContext(self.tableView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.tableView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    self.notInit = YES;
}


@end
