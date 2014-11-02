//
//  coubrCouponTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 19/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCouponTableViewCell.h"
#import "UIImage+ImageEffects.h"
#import "coubrLocale.h"

@interface coubrCouponTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *validToLabel;
@property (weak, nonatomic) IBOutlet UILabel *amontLabel;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrCouponTableViewCell

- (void)initCellWithCoupon:(Coupon *)coupon
{
    [self.titleLabel setText:coupon.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];

    [self.validToLabel setText:[NSString stringWithFormat:@"%@ %@", LOCALE_COUPON_VALID_UNTIL, [dateFormatter stringFromDate:coupon.validTo]]];
    
    [self.amontLabel setText:[NSString stringWithFormat:@"%lu %@", ([coupon.amount longValue] - [coupon.amountRedeemed longValue]), LOCALE_COUPON_AVAILABLE]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    viewImage = [viewImage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    self.backgroundView = [[UIImageView alloc] initWithImage:viewImage];
    
    self.notInit = YES;
}

@end
