//
//  coubrExploreTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "UIImage+ImageEffects.h"

#import "coubrExploreTableViewCell.h"
#import "ExploreCoupon.h"
//#import "UIImage+ImageEffects.h"

@interface coubrExploreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;

@end

@implementation coubrExploreTableViewCell

- (void)initCellWithExploreItem:(Explore *)explore
{
    [self.nameLabel setText:explore.name];
    
    double distance = [explore.distance doubleValue];
    if (distance < 1000) {
       [self.distanceLabel setText:[NSString stringWithFormat:@"%.0f m", [explore.distance doubleValue]]];
    } else {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.1f km", [(explore.distance) doubleValue] / 1000.0]];
    }

    if (explore.coupons.count == 1) {
        [self.couponsLabel setText:[NSString stringWithFormat:@"%lu coupon", explore.coupons.count]];
    } else if (explore.coupons.count > 0) {
        [self.couponsLabel setText:[NSString stringWithFormat:@"%lu coupons", explore.coupons.count]];
    }
    
    [self blurBackgroundImage];
    
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
}


@end
