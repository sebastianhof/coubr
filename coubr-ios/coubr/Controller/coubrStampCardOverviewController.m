//
//  coubrStampCardOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStampCardOverviewController.h"
#import "coubrQRScanController.h"


#import "Store.h"
#import "History+CRUD.h"

#import "coubrLocale.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"
#import "coubrRemoteManager+StampCard.h"

#import "UIImage+ImageEffects.h"

#import <AudioToolbox/AudioToolbox.h>

@interface coubrStampCardOverviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *stampsCollectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *footerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end

@implementation coubrStampCardOverviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableView];
    [self blurBackgroundImage];
}

#pragma mark - Init

- (void)initTableView
{
    // Header
    [self.titleLabel setText:self.stampCard.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_STAMP_CARD_VALID_UNTIL, [dateFormatter stringFromDate:self.stampCard.validTo]]];
    
    [self.stampsCollectedLabel setText:[NSString stringWithFormat:@"%lu %@ %lu %@", [self.stampCard.stampsCollected longValue], LOCALE_STAMP_CARD_COLLECTED_OF,  [self.stampCard.stamps longValue], LOCALE_STAMP_CARD_COLLECTED]];
    
    // Description
    [self.descriptionLabel setText:self.stampCard.stampCardDescription];
    
    // Footer
    [self.footerBackgroundImageView.layer setShadowOffset:CGSizeMake(-2.0, -2.0)];
    [self.footerBackgroundImageView.layer setShadowRadius:3.0];
    [self.footerBackgroundImageView.layer setShadowOpacity:0.05];
    
    [self.redeemButton setImage:[[UIImage imageNamed:@"StampCard_Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.redeemButton.layer setCornerRadius:((self.redeemButton.bounds.size.width + 20) / 2.0)];
    [self.redeemButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.redeemButton.layer setBorderWidth:4.0];
    
    [self.tableView reloadData];
    [self scrollToOffset];
}

#define TABLE_VIEW_TOP_OFFSET 36.0

- (void)scrollToOffset
{
    [self.tableView setContentOffset:CGPointMake(0, TABLE_VIEW_TOP_OFFSET) animated:NO];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
       self.stampCard.stampCardDescription.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.stampCard.stampCardDescription.length > 0) {
        return LOCALE_STAMP_CARD_DESCRIPTION;
    }
    return nil;
}

#define DEFAULT_HEADER_HEIGHT 150.0
#define DEFAULT_FOOTER_HEIGHT 99.0

#define DESCRIPTION_ROW_HEIGHT_MARGIN 16.0
#define DESCRIPTION_ROW_WIDTH_MARGIN 32.0

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return DEFAULT_HEADER_HEIGHT;
    } else if (indexPath.section == 1) {
        
        if (self.stampCard.stampCardDescription.length > 0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [self.stampCard.stampCardDescription boundingRectWithSize:CGSizeMake(cell.frame.size.width - DESCRIPTION_ROW_WIDTH_MARGIN, CGFLOAT_MAX)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                                                      context:nil];
            return rect.size.height + DESCRIPTION_ROW_HEIGHT_MARGIN;
        }
        
    } else if (indexPath.section == 2) {
        return DEFAULT_FOOTER_HEIGHT;
    }
    
    return 0;
}

#pragma mark - Navigation

#pragma mark - QRScan Delegate

- (void)didFailScanning
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showFailAlert];
    });
}

- (void)didScanQRCode:(NSString *)storeCode
{
    
    [[coubrRemoteManager defaultManager]
     stampStampCardWithStampCardId:self.stampCard.stampCardId storeId:self.stampCard.store.storeId andStoreCode:storeCode
     completionHandler:^{
         
         if (![History insertHistoryIntoDatabaseFromStampCard:self.stampCard]) {
             NSLog(@"Could not add stamp to history");
         }
         
         // decrement in database until new fetch
         NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
         [context performBlockAndWait:^{
             self.stampCard.stampsCollected = [NSNumber numberWithInteger:[self.stampCard.stampsCollected integerValue] + 1];
         }];
         
         // show success alert
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.stampsCollectedLabel setText:[NSString stringWithFormat:@"%lu %@ %lu %@", [self.stampCard.stampsCollected longValue], LOCALE_STAMP_CARD_COLLECTED_OF,  [self.stampCard.stamps longValue], LOCALE_STAMP_CARD_COLLECTED]];
             [self showSuccessAlert];
         });
         
     } errorHandler:^(NSInteger errorCode) {
         
         if (errorCode == STORE_CODE_NOT_FOUND_ERROR) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showFailAlert];
             });
             
         } else if (errorCode == SERVER_ERROR || errorCode == STORE_NOT_FOUND_ERROR || errorCode == 1000) {
             
             // show internal error alert
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showInternalErrorAlert];
             });
             
         }
         
     }];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showStampCardQRScan"]) {
        
        if ([segue.destinationViewController isKindOfClass:[coubrQRScanController class]]) {
            coubrQRScanController *qr = (coubrQRScanController *) segue.destinationViewController;
            [qr setDelegate: self];
        }
        
    }
    
}

#pragma mark - Alert

#define SIMToolKitNegative 1053
#define CALYPSO 1022

- (void)showSuccessAlert
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(CALYPSO);
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_STAMP_CARD_ALERT_CONGRATULATIONS message:LOCALE_STAMP_CARD_ALERT_REDEMPTION_SUCCESS delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
    [alert show];
}

- (void)showFailAlert
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(SIMToolKitNegative);
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_STAMP_CARD_ALERT_OOPS message:LOCALE_STAMP_CARD_ALERT_CODE_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
    [alert show];
}

- (void)showInternalErrorAlert
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(SIMToolKitNegative);
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_STAMP_CARD_ALERT_OOPS message:LOCALE_INTERNAL_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

#pragma mark - Blur

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
}

@end
