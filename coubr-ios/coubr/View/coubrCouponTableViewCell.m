//
//  coubrCouponTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 07/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCouponTableViewCell.h"
#import "coubrCouponOverviewController.h"
#import "coubrLocale.h"
#import "UIImage+ImageEffects.h"

@interface coubrCouponTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (nonatomic) BOOL notInit;

@property (weak, nonatomic) Coupon *coupon;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation coubrCouponTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoupon)];
    }
    return _tapRecognizer;
}

- (void)initCellWithCoupon:(Coupon *)coupon
{
    self.coupon = coupon;
    
    [self.titleLabel setText:coupon.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_COUPON_VALID_UNTIL, [dateFormatter stringFromDate:coupon.validTo]]];
    
    [self.amountLabel setText:[NSString stringWithFormat:@"%lu %@", ([coupon.amount longValue] - [coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];
}

- (void)showCoupon
{
    coubrCouponOverviewController *covc = [[UIStoryboard storyboardWithName:@"Store" bundle:nil]  instantiateViewControllerWithIdentifier:@"coubrCouponOverviewViewController"];
    [covc setCoupon:self.coupon];
    [self.parentController.navigationController pushViewController:covc animated:YES];
}

- (void)blurBackgroundImage
{
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundImageView setClipsToBounds:YES];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"Coupon-bg"]];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:viewImage];
    
    [self.foregroundImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.foregroundImageView.layer setBorderWidth: 4.0];
    [self.backgroundImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.backgroundImageView.layer setBorderWidth: 4.0];
    
    
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
    
    self.notInit = YES;
}



@end
