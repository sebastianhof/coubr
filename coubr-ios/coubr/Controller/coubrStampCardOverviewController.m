//
//  coubrStampCardOverviewController.m
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStampCardOverviewController.h"
#import "coubrStampCardDescriptionTableViewCell.h"
#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrStampCardOverviewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *stampsCollectedLabel;

@property (weak, nonatomic) IBOutlet UITableView *stampCardTableView;

@property (weak, nonatomic) IBOutlet UIButton *redeemButton;

@property (weak, nonatomic) IBOutlet UIImageView *footerBackgroundImageView;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrStampCardOverviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleLabel setText:self.stampCard.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_STAMP_CARD_VALID_UNTIL, [dateFormatter stringFromDate:self.stampCard.validTo]]];
    
    [self.stampsCollectedLabel setText:[NSString stringWithFormat:@"%lu %@ %lu %@", [self.stampCard.stampsCollected longValue], LOCALE_STAMP_CARD_COLLECTED_OF,  [self.stampCard.stamps longValue], LOCALE_STAMP_CARD_COLLECTED]];
    
    [self initButton];
    [self blurBackgroundImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_notInit) {
        [self blurTableViewBackground];
        [self initFooterBackgroundView];
    }
}

#pragma mark - Init

- (void)initButton
{
    
    [self.redeemButton setImage:[[UIImage imageNamed:@"StampCard_Scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [self.redeemButton.layer setCornerRadius:((self.redeemButton.bounds.size.width + 20) / 2.0)];
    [self.redeemButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.redeemButton.layer setBorderWidth:4.0];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.stampCard.stampCardDescription) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.stampCard.stampCardDescription) {
        return 1;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return LOCALE_STAMP_CARD_DESCRIPTION;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.stampCard.stampCardDescription) {
            return [self initializeDescriptionTableViewCell];
        }
        
    }
    return nil;
}

- (UITableViewCell *)initializeDescriptionTableViewCell
{
    
    UITableViewCell *cell = [self.stampCardTableView dequeueReusableCellWithIdentifier:@"coubrStampCardDescriptionTableViewCell"];
    if ([cell isKindOfClass:[coubrStampCardDescriptionTableViewCell class]]) {
        
        [((coubrStampCardDescriptionTableViewCell *)cell).descriptionTextView setText:self.stampCard.stampCardDescription];
    }
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if ([segue.identifier isEqualToString:@"showQRCodeScan"]) {
//        
//        if ([segue.destinationViewController isKindOfClass:[coubrCouponQRScanController class]]) {
//            
//            coubrCouponQRScanController *qr = (coubrCouponQRScanController *) segue.destinationViewController;
//            [qr setParentController: self];
//        }
//        
//    }
    
}

#pragma mark - Redeem

//- (void)didFailToRedeem
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_COUPON_ALERT_CODE_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
//        [alert show];
//    });
//    
//}

//- (void)willRedeemWithCode:(NSString *)code
//{
//    
//    [[coubrRemoteManager defaultManager] redeemCouponWithCouponId:self.coupon.offerId storeId:self.coupon.store.storeId andStoreCode:code
//                                                completionHandler:^{
//                                                    
//                                                    if (![History insertHistoryIntoDatabaseFromCoupon:self.coupon]) {
//                                                        
//                                                        NSLog(@"Could not add coupon to history");
//                                                        
//                                                        // TODO inform server;
//                                                        return;
//                                                        
//                                                    }
//                                                    
//                                                    // decrement in database until new fetch
//                                                    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
//                                                    
//                                                    [context performBlockAndWait:^{
//                                                        
//                                                        self.coupon.amountRedeemed = [NSNumber numberWithInteger:[self.coupon.amountRedeemed integerValue] + 1];
//                                                        
//                                                    }];
//                                                    
//                                                    // show success alert
//                                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                                        
//                                                        // update label
//                                                        //[self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([self.coupon.amount longValue] - [self.coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
//                                                        
//                                                        // deactivate button
//                                                        self.redeemButton.enabled = NO;
//                                                        
//                                                        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_CONGRATULATIONS message:LOCALE_COUPON_ALERT_REDEMPTION_SUCCESS delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
//                                                        [alert show];
//                                                        
//                                                        
//                                                    });
//                                                    
//                                                } errorHandler:^(NSInteger errorCode) {
//                                                    
//                                                    if (errorCode == STORE_CODE_NOT_FOUND_ERROR) {
//                                                        
//                                                        [self didFailToRedeem];
//                                                        
//                                                    } else if (errorCode == SERVER_ERROR || errorCode == STORE_NOT_FOUND_ERROR || errorCode == STORE_CODE_NOT_FOUND_ERROR) {
//                                                        
//                                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                                            
//                                                            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:LOCALE_COUPON_ALERT_OOPS message:LOCALE_INTERNAL_ERROR delegate:self cancelButtonTitle:LOCALE_ALERT_OK otherButtonTitles: nil];
//                                                            [alert show];
//                                                            
//                                                        });
//                                                        
//                                                    }
//                                                    
//                                                }];
//    
//}

#pragma mark - Alert View

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
//    }
//}

- (void)blurBackgroundImage
{
//    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.backgroundImageView setClipsToBounds:YES];
//    [self.backgroundImageView setImage:[UIImage imageNamed:@"Coupon_Tile"]];
    
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

- (void)initFooterBackgroundView
{
    [self.footerBackgroundImageView.layer setShadowOffset:CGSizeMake(-2.0, -2.0)];
    [self.footerBackgroundImageView.layer setShadowRadius:3.0];
    [self.footerBackgroundImageView.layer setShadowOpacity:0.05];
    
}

- (void)blurTableViewBackground
{
    UIGraphicsBeginImageContext(self.stampCardTableView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.stampCardTableView.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.stampCardTableView.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    self.notInit = YES;
}



@end
