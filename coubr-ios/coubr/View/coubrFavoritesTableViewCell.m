//
//  coubrFavoritesTableViewCell.m
//  coubr
//
//  Created by Sebastian Hof on 23/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrFavoritesTableViewCell.h"
#import "coubrStoreViewController.h"

#import "coubrCategoryToText.h"
#import "coubrLocationManager.h"

#import "UIImage+ImageEffects.h"

#import <MapKit/MapKit.h>

@interface coubrFavoritesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *offersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView3;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property (weak, nonatomic) NSString *storeId;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic) BOOL notInit;

@end

@implementation coubrFavoritesTableViewCell

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStore)];
    }
    return _tapRecognizer;
}

- (void)initCellWithStore:(Store *)store
{
    self.storeId = store.storeId;
    
    [self.nameLabel setText:store.name];
    
    [self.categoryLabel setText:[coubrCategoryToText textFromStoreCategory:store.category andStoreSubcategory:store.subcategory]];
    
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:[store.distance doubleValue]]];
    
    [self.offersImageView1 setImage:nil];
    [self.offersImageView2 setImage:nil];
    [self.offersImageView3 setImage:nil];
    
    if (store.coupons.count > 0) {
        
        // rightImageView
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_Coupon"]];
        
        if (store.stampCards.count > 0) {
            
            [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
            
            if (store.specialOffers.count > 0) {
                [self.offersImageView3 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
            }
            
        }
        
    } else if (store.stampCards.count > 0) {
        
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_StampCard"]];
        
        if (store.specialOffers.count > 0) {
            [self.offersImageView2 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
        }
        
    } else if (store.specialOffers.count > 0) {
        [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_SpecialOffer"]];
    }
    
    
    if (!self.notInit) {
        [self blurBackgroundImage];
    }
    
    [self.foregroundImageView addGestureRecognizer:self.tapRecognizer];
}

- (void)showStore
{
    if (self.storeId) {
        coubrStoreViewController *svc = [[UIStoryboard storyboardWithName:@"Store" bundle:nil]  instantiateViewControllerWithIdentifier:@"coubrStoreViewController"];
        
        [svc setCurrentIndex:[self.parentController.storeIds indexOfObject:self.storeId]];
        [svc setDelegate:self.parentController];
        
        [self.parentController.navigationController pushViewController:svc animated:YES];
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
