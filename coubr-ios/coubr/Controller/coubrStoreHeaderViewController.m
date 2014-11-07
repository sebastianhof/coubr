//
//  coubrStoreHeaderViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreHeaderViewController.h"
#import "coubrDatabaseManager.h"
#import "coubrLocationManager.h"
#import "coubrLocale.h"
#import "coubrCategoryToText.h"
#import <MapKit/MapKit.h>
#import "UIImage+ImageEffects.h"

@interface coubrStoreHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *offersImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *offersImageView2;

@property (weak, nonatomic) IBOutlet UILabel *offersLabel1;
@property (weak, nonatomic) IBOutlet UILabel *offersLabel2;


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@end

@implementation coubrStoreHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self storeDidBecomeAvailable];
    }];
    
    [self storeDidBecomeAvailable];
}

- (void)storeDidBecomeAvailable
{
    if (self.parentController.store) {
     
        __block CLLocation *storeLocation;
        
        [[[coubrDatabaseManager defaultManager] managedObjectContext] performBlockAndWait:^{

            [self.nameLabel setText:self.parentController.store.name];
            
            CLLocationDegrees latitude = [self.parentController.store.latitude doubleValue] ;
            CLLocationDegrees longitude = [self.parentController.store.longitude doubleValue];
            
            storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

            CLLocationDistance distance = [storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] userLocation]];
            
            // distance
            MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
            [distanceFormatter setLocale:[NSLocale currentLocale]];
            [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
            [self.distanceLabel setText:[distanceFormatter stringFromDistance:distance]];
            
            // coupons
            if (self.parentController.store.coupons.count > 0) {
                
                // rightImageView
                [self.offersImageView1 setImage:[UIImage imageNamed:@"Explore_Coupon"]];
                [self.offersLabel1 setText:[NSString stringWithFormat:@"%lu", self.parentController.store.coupons.count]];
                
            } else {
                [self.offersLabel1 setText:@""];
            }
            
            [self.offersLabel2 setText:@""];
            
            [self.categoryLabel setText:[coubrCategoryToText textFromCategory:self.parentController.store.category andSubcategory:self.parentController.store.subcategory]];
            
        }];
        
        [self blurBackgroundImage];
        
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
    
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* blurimage = UIGraphicsGetImageFromCurrentImageContext();
    
    blurimage = [blurimage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:blurimage];
    [self.foregroundImageView.layer setShadowOffset:CGSizeMake(-2.0, 2.0)];
    [self.foregroundImageView.layer setShadowRadius:3.0];
    [self.foregroundImageView.layer setShadowOpacity:0.05];
}

- (IBAction)toggleFavorite:(id)sender {

    [[[coubrDatabaseManager defaultManager] managedObjectContext ] performBlockAndWait:^{

        if ([self.parentController.store.isFavorite boolValue] == YES) {
            [self.parentController.store setIsFavorite:[NSNumber numberWithBool:NO]];
            [self.favoriteButton setSelected:NO];
        } else {
            [self.parentController.store setIsFavorite:[NSNumber numberWithBool:YES]];
            [self.favoriteButton setSelected:YES];
        }
        
    }];
    
}

@end
