//
//  coubrCouponOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCouponOverviewController.h"
#import "coubrCouponQRScanController.h"
#import "coubrRemoteManager+Coupon.h"
#import "coubrDatabaseManager.h"
#import "coubrConstants.h"
#import "coubrLocale.h"
#import "Store.h"
#import "History+CRUD.h"
#import "UIImage+ImageEffects.h"

@interface coubrCouponOverviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

@end

@implementation coubrCouponOverviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleLabel setText:self.coupon.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_COUPON_VALID_UNTIL, [dateFormatter stringFromDate:self.coupon.validTo]]];
    
    [self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([self.coupon.amount longValue] - [self.coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
 
    [self.descriptionTextView setText: self.coupon.couponDescription ? self.coupon.couponDescription : LOCALE_COUPON_NO_DESCRIPTION];
    
    [self blurBackgroundImage];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showQRCodeScan"]) {
        
        if ([segue.destinationViewController isKindOfClass:[coubrCouponQRScanController class]]) {
            
            coubrCouponQRScanController *qr = (coubrCouponQRScanController *) segue.destinationViewController;
            [qr setParentController: self];
        }
        
    }
    
}

#pragma mark - Redeem

- (void)didFailToRedeem
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_COUPON_ALERT_CODE_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
        [alert show];
    });

}

- (void)willRedeemWithCode:(NSString *)code
{
    
    [[coubrRemoteManager defaultManager] redeemCouponWithCouponId:self.coupon.couponId storeId:self.coupon.store.storeId andStoreCode:code
    completionHandler:^{

        if (![History insertHistoryIntoDatabaseFromCoupon:self.coupon]) {
            
            NSLog(@"Could not add coupon to history");
            
            // TODO inform server;
            return;
            
        }
        
        // decrement in database until new fetch
        NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
        
        [context performBlockAndWait:^{
            
            self.coupon.amountRedeemed = [NSNumber numberWithInteger:[self.coupon.amountRedeemed integerValue] + 1];
            
        }];
        
        // show success alert
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // update label
            [self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([self.coupon.amount longValue] - [self.coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
            
            // deactivate button
            self.redeemButton.enabled = NO;

            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_CONGRATULATIONS message:LOCALE_COUPON_ALERT_REDEMPTION_SUCCESS delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
            [alert show];

            
        });

    } errorHandler:^(NSInteger errorCode) {
        
        if (errorCode == STORE_CODE_NOT_FOUND_ERROR) {
        
            [self didFailToRedeem];
            
        } else if (errorCode == SERVER_ERROR || errorCode == STORE_NOT_FOUND_ERROR || errorCode == STORE_CODE_NOT_FOUND_ERROR) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_INTERNAL_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
                [alert show];
                
            });
            
        }
        
    }];
     
}

#pragma mark - Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
}

@end
