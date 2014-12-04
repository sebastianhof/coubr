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
#import "coubrCategoryToText.h"

#import "coubrStoreViewController.h"

@interface coubrExploreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@property (weak, nonatomic) IBOutlet UIImageView *offersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView3;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) Explore *explore;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrExploreTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStore)];
    }
    return _tapRecognizer;
}

- (void)initCellWithExplore:(Explore *)explore
{
    self.explore = explore;
    
    // name
    [self.nameLabel setText:explore.name];
    
    // distance
    
    CLLocationDistance distance = [explore.distance doubleValue];
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:distance]];
    
    [self.offersImageView1 setImage:nil];
    [self.offersImageView2 setImage:nil];
    [self.offersImageView3 setImage:nil];
    
    if ([explore.coupons integerValue] > 0) {
        
        // rightImageView
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_Coupon"]];
        
        if ([explore.stampCards integerValue] > 0) {
            
            [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
            
            if ([explore.specialOffers integerValue] > 0) {
                [self.offersImageView3 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
            }
            
        }
        
    } else if ([explore.stampCards integerValue] > 0) {
        
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
        
        if ([explore.specialOffers integerValue] > 0) {
           [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
        }
        
    } else if ([explore.specialOffers integerValue] > 0) {
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
    }
    
    [self.categoryLabel setText:[coubrCategoryToText textFromStoreCategory:explore.category andStoreSubcategory:explore.subcategory]];
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];
}

- (void)showStore
{
    if (self.explore.storeId) {
        coubrStoreViewController *spvc = [[UIStoryboard storyboardWithName:@"Store" bundle:nil]  instantiateViewControllerWithIdentifier:@"coubrStoreViewController"];
        
        [spvc setCurrentIndex:[self.parentController.storeIds indexOfObject:self.explore.storeId]];
        [spvc setDelegate:self.parentController];
      
        [self.parentController.navigationController pushViewController:spvc animated:YES];
    }
}

- (void)blurBackgroundImage
{
    [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.backgroundImageView setClipsToBounds:YES];
    
    NSInteger randomNumber = arc4random() % 3;
    UIImage *image;
    if (randomNumber == 0) {
        image = [UIImage imageNamed:@"Explore_Image1"];
    } else if (randomNumber == 1) {
        image = [UIImage imageNamed:@"Explore_Image2"];
    } else if (randomNumber == 2) {
        image = [UIImage imageNamed:@"Explore_Image3"];
    } else {
        image = [UIImage imageNamed:@"Explore_Image1"];
    }
    [self.backgroundImageView setImage:image];
    
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
