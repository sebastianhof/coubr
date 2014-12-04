//
//  coubrStoreInformationTableViewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreInformationTableViewController.h"
#import "coubrStoreViewController.h"

#import "Store+CRUD.h"
#import "StoreOpeningTime.h"

#import "coubrLocale.h"

#import <CoreData/CoreData.h>
#import "UIImage+ImageEffects.h"
@interface coubrStoreInformationTableViewController ()

@property (weak, nonatomic) Store *store;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@property (weak, nonatomic) IBOutlet UILabel *todayOpeningTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *openingTimesLabel;

@property (nonatomic) BOOL isShowingOpeningTimesDetails;

@end

@implementation coubrStoreInformationTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:self.parentViewController.parentViewController queue:nil usingBlock:^ (NSNotification *note) {
        self.store = note.userInfo[STORE];
        [self initTable];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.store) {
        [self.tableView reloadData];
    }
    
}


#pragma mark - Table View Delegate

- (NSString *)weekDayFromInt:(NSInteger)integer
{
    if (integer == 1) {
        return LOCALE_SUNDAY;
    } else if (integer == 2) {
        return LOCALE_MONDAY;
    } else if (integer == 3) {
        return LOCALE_TUESDAY;
    } else if (integer == 4) {
        return LOCALE_WEDNESDAY;
    } else if (integer == 5) {
       return LOCALE_THURSDAY;
    } else if (integer == 6) {
        return LOCALE_FRIDAY;
    } else if (integer == 7) {
        return LOCALE_SATURDAY;
    }
     
    return nil;
}

- (void)initTable
{
    [self.descriptionLabel setText:self.store.storeDescription];
    [self.streetLabel setText:self.store.street];
    [self.cityLabel setText:[NSString stringWithFormat:@"%@ %@", self.store.postalCode, self.store.city]];
    [self.phoneButton setTitle:self.store.phone forState:UIControlStateNormal];
    [self.phoneButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.phoneButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailButton setTitle:self.store.email forState:UIControlStateNormal];
    [self.emailButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.emailButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.websiteButton setTitle:self.store.website forState:UIControlStateNormal];
    [self.websiteButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [self.websiteButton addTarget:self action:@selector(openWebsite:) forControlEvents:UIControlEventTouchUpInside];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =  [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
                                     
    NSString *openingTimesString = @"";
    NSString *todayOpeningTimeString;
    NSArray *openingTimes = [self.store.openingTimes sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"weekDay"
                                                                                  ascending:YES] ]];
    
    for (StoreOpeningTime *openingTime in openingTimes) {
      
        NSString *time = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d", [openingTime.beginHour intValue], [openingTime.beginMinute intValue], [openingTime.endHour intValue], [openingTime.endMinute intValue]];
        
        if (components.weekday == [openingTime.weekDay integerValue]) {

            if (todayOpeningTimeString) {
                todayOpeningTimeString = [todayOpeningTimeString stringByAppendingString:[NSString stringWithFormat:@" %@", time]];
            } else {
                todayOpeningTimeString = time;
            }
        
        }
        
        NSString *weekday = [[self weekDayFromInt:[openingTime.weekDay integerValue]] stringByPaddingToLength:20 withString:@" " startingAtIndex:0];
        openingTimesString = [openingTimesString stringByAppendingString:[NSString stringWithFormat:@"%@\t%@\n", weekday, time]];
      
    }
    
    [self.todayOpeningTimesLabel setText:todayOpeningTimeString ? todayOpeningTimeString : LOCALE_STORE_OPENING_TIME_CLOSED];
    [self.openingTimesLabel setText:openingTimesString];
    [self.openingTimesLabel setHidden:YES];
    
    [self.tableView reloadData];
}

#define EMPTY_ROW_HEIGHT 0
#define DEFAULT_ROW_HEIGHT 44.0
#define DEFAULT_ADDRESS_ROW_HEIGHT 66.0
#define DEFAULT_CONTACT_ROW_HEIGHT 44.0
#define DEFAULT_OPENING_TIMES_ROW_HEIGHT 66.0
#define DESCRIPTION_ROW_HEIGHT_MARGIN 16.0
#define DESCRIPTION_ROW_WIDTH_MARGIN 32.0
#define OPENING_TIMES_LINE_HEIGHT

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.store.storeDescription.length > 0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [self.store.storeDescription boundingRectWithSize:CGSizeMake(cell.frame.size.width - DESCRIPTION_ROW_WIDTH_MARGIN, CGFLOAT_MAX)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                                                    context:nil];
            return rect.size.height + DESCRIPTION_ROW_HEIGHT_MARGIN;
        }
        
    } else if (indexPath.section == 1) {
        
        CGFloat height = (self.store.street.length > 0 && self.store.postalCode.length > 0 && self.store.city.length > 0) ? DEFAULT_ADDRESS_ROW_HEIGHT : EMPTY_ROW_HEIGHT;
        return height;

    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            CGFloat height = self.store.phone.length > 0 ? DEFAULT_CONTACT_ROW_HEIGHT : EMPTY_ROW_HEIGHT;
            return height;
        } else if (indexPath.row == 1) {
            CGFloat height = self.store.email.length > 0 ? DEFAULT_CONTACT_ROW_HEIGHT : EMPTY_ROW_HEIGHT;
            return height;
        } else if (indexPath.row == 2) {
            CGFloat height = self.store.website.length > 0 ? DEFAULT_CONTACT_ROW_HEIGHT : EMPTY_ROW_HEIGHT;
            return height;
        }
        
    } else if (indexPath.section == 3) {
        
        if (self.store.openingTimes.count > 0) {
            
            if (self.isShowingOpeningTimesDetails) {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                CGRect rect = [self.openingTimesLabel.text boundingRectWithSize:CGSizeMake(cell.frame.size.width - DESCRIPTION_ROW_WIDTH_MARGIN, CGFLOAT_MAX)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                                                        context:nil];
                return rect.size.height + DESCRIPTION_ROW_HEIGHT_MARGIN + DEFAULT_OPENING_TIMES_ROW_HEIGHT;
            } else {
                return DEFAULT_OPENING_TIMES_ROW_HEIGHT;
            }
            
            
        }
        
    }

    return EMPTY_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.store.description.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
    } else if (indexPath.section == 1) {
        (self.store.street.length > 0 && self.store.postalCode.length > 0 && self.store.city.length > 0) ? [cell setHidden:NO] : [cell setHidden:YES];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            self.store.phone.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
        } else if (indexPath.row == 1) {
            self.store.email.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
        } else if (indexPath.row == 2) {
            self.store.website.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
        }
    } else if (indexPath.section == 3) {
        self.store.openingTimes.count > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleForHeaderInSection;
    
    if (section == 0) {
        titleForHeaderInSection = self.store.storeDescription.length > 0 ? LOCALE_STORE_DESCRIPTION : nil;
    } else if (section == 1) {
        titleForHeaderInSection = (self.store.street.length > 0 && self.store.postalCode.length > 0 && self.store.city.length > 0) ? LOCALE_STORE_ADDRESS : nil;
    } else if (section == 2) {
         titleForHeaderInSection = (self.store.phone.length > 0 || self.store.email.length > 0 || self.store.website.length > 0) ? LOCALE_STORE_CONTACT : nil;
    } else if (section == 3) {
        titleForHeaderInSection =self.store.openingTimes.count > 0 ? LOCALE_STORE_OPENING_TIMES: nil;
    }
    
    return titleForHeaderInSection;
}

#pragma mark - IBAction

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



 - (IBAction)toggleDetails:(UIButton *)sender {
     
     [sender setSelected:!sender.isSelected];
     self.isShowingOpeningTimesDetails = sender.isSelected;
     
     if ([sender isSelected]) {
         [self.openingTimesLabel setHidden:NO];
         
         [self.tableView reloadData];
         [self.view updateConstraints];
         
         [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.openingTimesLabel.frame.size.height) animated:YES];
     } else {
         [self.openingTimesLabel setHidden:YES];
         
         [self.tableView reloadData];
     }
     
}

@end
