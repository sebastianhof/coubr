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
#import "coubrTypesToImage.h"
#import <MapKit/MapKit.h>
#import "UIImage+ImageEffects.h"

@interface coubrStoreHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subcategoryImageView;

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

            CLLocationDistance distance = [storeLocation distanceFromLocation:[[coubrLocationManager defaultManager] lastLocation]];
            
            // distance
            
            MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
            [distanceFormatter setLocale:[NSLocale currentLocale]];
            [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleAbbreviated];
            [self.distanceLabel setText:[distanceFormatter stringFromDistance:distance]];
            
            // coupons
            
            if (self.parentController.store.coupons.count == 1) {
                [self.couponsLabel setText:[NSString stringWithFormat:@"%lu %@", self.parentController.store.coupons.count, LOCALE_STORE_COUPON]];
            } else if (self.parentController.store.coupons.count > 0) {
                [self.couponsLabel setText:[NSString stringWithFormat:@"%lu %@", self.parentController.store.coupons.count, LOCALE_STORE_COUPONS]];
            }
            
            // type
            // TODO at the moment we only support food establishments - do not set type - set category instead
            if (self.parentController.store.category) {
                [self.typeImageView setImage:[coubrTypesToImage imageForCategory:self.parentController.store.category]];
            }
            
            if (self.parentController.store.subcategory) {
                [self.categoryImageView setImage:[coubrTypesToImage imageForSubcategory:self.parentController.store.subcategory]];
            }
            
            if ([self.parentController.store.isFavorite boolValue] == YES) {
                [self.favoriteButton setSelected:YES];
            } else {
                [self.favoriteButton setSelected:NO];
            }
            
        }];
        
        [self storeLocationDidBecomeAvailable:storeLocation];
        
    }

}

#define STORE_REGION_RADIUS 100.0

- (void)storeLocationDidBecomeAvailable:(CLLocation *)storeLocation
{

    // use map snapshotter
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = MKCoordinateRegionMakeWithDistance(storeLocation.coordinate, STORE_REGION_RADIUS, STORE_REGION_RADIUS);
    options.scale = [[UIScreen mainScreen] scale];
    options.size = self.view.bounds.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        if (error) {
            NSLog(@"Could make map snapshot: %@", [error localizedDescription]);
            return;
        }
        
        MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
        
        UIImage *mapImage = snapshot.image;
        UIGraphicsBeginImageContextWithOptions(mapImage.size, YES, mapImage.scale);
        {
            [mapImage drawAtPoint:CGPointMake(0.0f, 0.0f)];
            
            CGRect rect = CGRectMake(0.0f, 0.0f, mapImage.size.width, mapImage.size.height);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:storeLocation.coordinate];

            CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
            if (CGRectContainsPoint(rect, point)) {
                point.x = point.x + pin.centerOffset.x -
                (pin.bounds.size.width / 2.0f);
                point.y = point.y + pin.centerOffset.y -
                (pin.bounds.size.height / 2.0f);
                [pin.image drawAtPoint:point];
            }
            mapImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [self.backgroundImageView setImage:mapImage];
            [self blurBackgroundImage];
        });
        
    }];
    
}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.backgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.backgroundImageView.layer renderInContext:c];
    
    UIImage* blurimage = UIGraphicsGetImageFromCurrentImageContext();
    
    blurimage = [blurimage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.foregroundImageView setImage:blurimage];
}

- (IBAction)swipeUp:(UISwipeGestureRecognizer *)sender {
    [self.parentController scrollToBottom];
}


- (IBAction)swipeDown:(UISwipeGestureRecognizer *)sender {
    [self.parentController scrollToTop];
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
