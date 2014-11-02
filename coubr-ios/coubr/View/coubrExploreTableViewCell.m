//
//  coubrExploreTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 16.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "UIImage+ImageEffects.h"
#import <MapKit/MapKit.h>

#import "coubrLocale.h"
#import "coubrExploreTableViewCell.h"
#import "coubrTypesToImage.h"


@interface coubrExploreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subcategoryImageView;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrExploreTableViewCell

- (void)initCellWithExplore:(Explore *)explore
{
    
    // name
    [self.nameLabel setText:explore.name];
    
    // distance
    
    CLLocationDistance distance = [explore.distance doubleValue];
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:distance]];
    
    // coupons

    if ([explore.coupons integerValue] == 1) {
        [self.couponsLabel setText:[NSString stringWithFormat:@"%lu %@", [explore.coupons integerValue], LOCALE_STORE_COUPON]];
    } else if ([explore.coupons integerValue] > 0) {
        [self.couponsLabel setText:[NSString stringWithFormat:@"%lu %@", [explore.coupons integerValue], LOCALE_STORE_COUPONS]];
    }
    
    // type
    // TODO at the moment we only support food establishments - do not set type - set category instead
    if (explore.category) {
        [self.typeImageView setImage:[coubrTypesToImage imageForCategory:explore.category]];
    }
    
    if (explore.subcategory) {
        [self.categoryImageView setImage:[coubrTypesToImage imageForSubcategory:explore.subcategory]];
    }

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
