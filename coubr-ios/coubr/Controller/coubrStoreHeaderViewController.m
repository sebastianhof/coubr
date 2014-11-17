//
//  coubrStoreHeaderViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrStoreHeaderViewController.h"
#import "coubrStoreViewController.h"

#import "coubrDatabaseManager.h"
#import "coubrLocationManager.h"
#import "coubrLocale.h"

#import "coubrCategoryToText.h"

#import <MapKit/MapKit.h>
#import "UIImage+ImageEffects.h"

@interface coubrStoreHeaderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *foregroundImageView;

@property Store *store;

@end

@implementation coubrStoreHeaderViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:StoreDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        self.store = note.userInfo[STORE];
        [self initStoreHeader];
        
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initStoreHeader
{
    [self.nameLabel setText:self.store.name];
    
    CLLocationDegrees latitude = [self.store.latitude doubleValue] ;
    CLLocationDegrees longitude = [self.store.longitude doubleValue];
    
    CLLocation *storeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    CLLocationDistance distance = [storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] userLocation]];
    
    // distance
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
    [self.distanceLabel setText:[distanceFormatter stringFromDistance:distance]];
    
    [self.categoryLabel setText:[coubrCategoryToText textFromCategory:self.store.category andSubcategory:self.store.subcategory]];
    [self blurBackgroundImage];
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



@end
