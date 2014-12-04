//
//  coubrCouponOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCouponOverviewController.h"
#import "coubrQRScanController.h"
#import "coubrRemoteManager+Coupon.h"
#import "coubrDatabaseManager.h"

#import "coubrConstants.h"
#import "coubrLocale.h"

#import "Store.h"
#import "History+CRUD.h"

#import "UIImage+ImageEffects.h"

#import <AudioToolbox/AudioToolbox.h>

@interface coubrCouponOverviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

@property (weak, nonatomic) IBOutlet UIImageView *footerBackgroundImageView;

@end

@implementation coubrCouponOverviewController

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
    [self.titleLabel setText:self.coupon.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_COUPON_VALID_UNTIL, [dateFormatter stringFromDate:self.coupon.validTo]]];
    
    [self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([self.coupon.amount longValue] - [self.coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
    
    // Description
    [self.descriptionLabel setText:self.coupon.couponDescription];
    
    // Footer
    [self.footerBackgroundImageView.layer setShadowOffset:CGSizeMake(-2.0, -2.0)];
    [self.footerBackgroundImageView.layer setShadowRadius:3.0];
    [self.footerBackgroundImageView.layer setShadowOpacity:0.05];
    
    [self.redeemButton setImage:[[UIImage imageNamed:@"Coupon_Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
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
        self.coupon.couponDescription.length > 0 ? [cell setHidden:NO] : [cell setHidden:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.coupon.couponDescription.length > 0) {
        return LOCALE_COUPON_DESCRIPTION;
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
        
        if (self.coupon.couponDescription.length > 0) {
            UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGRect rect = [self.coupon.couponDescription boundingRectWithSize:CGSizeMake(cell.frame.size.width - DESCRIPTION_ROW_WIDTH_MARGIN, CGFLOAT_MAX)
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
        redeemCouponWithCouponId:self.coupon.couponId storeId:self.coupon.store.storeId andStoreCode:storeCode
        completionHandler:^{
                                                    
            if (![History insertHistoryIntoDatabaseFromCoupon:self.coupon]) {
                NSLog(@"Could not add coupon to history");
            }
            
            // decrement in database until new fetch
            NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
            [context performBlockAndWait:^{
                self.coupon.amountRedeemed = [NSNumber numberWithInteger:[self.coupon.amountRedeemed integerValue] + 1];
            }];
            
            // show success alert
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([self.coupon.amount longValue] - [self.coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
                [self showSuccessAlert];
            });
     
     } errorHandler:^(NSInteger errorCode) {
         
         if (errorCode == STORE_CODE_NOT_FOUND_ERROR) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showFailAlert];
             });
             
         } else if (errorCode == SERVER_ERROR || errorCode == STORE_NOT_FOUND_ERROR) {
             
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
    if ([segue.identifier isEqualToString:@"showCouponQRScan"]) {

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
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_CONGRATULATIONS message:LOCALE_COUPON_ALERT_REDEMPTION_SUCCESS delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
    [alert show];
}

- (void)showFailAlert
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(SIMToolKitNegative);

    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_COUPON_ALERT_CODE_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
    [alert show];
}

- (void)showInternalErrorAlert
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(SIMToolKitNegative);
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_INTERNAL_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
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
