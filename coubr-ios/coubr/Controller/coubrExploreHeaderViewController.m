//
//  coubrExploreHeaderViewController.m
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrExploreHeaderViewController.h"

#import "UIImage+ImageEffects.h"

#import "coubrLocationManager.h"

@interface coubrExploreHeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerForegroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerLocationTitle;

@end

@implementation coubrExploreHeaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationDidBecomeAvailableNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self locationDidBecomeAvailable];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:LocationDidFailNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self locationDidFail];
    }];
    
}

#pragma mark - init

#define REGION_RADIUS 1000.0;

- (void)locationDidBecomeAvailable
{
    CLLocation *location = [[coubrLocationManager defaultManager] lastLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    CLLocationDistance distance = REGION_RADIUS;
 
    // use map snapshotter
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance);
    options.scale = [[UIScreen mainScreen] scale];
    options.size = self.view.bounds.size;
    
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        if (error) {
            NSLog(@"Could make map snapshot: %@", [error localizedDescription]);
            return;
        }
        
        UIImage *mapImage = snapshot.image;
        
        dispatch_async(dispatch_get_main_queue(), ^ {

            [self.headerBackgroundImageView setImage:mapImage];
            [self blurBackgroundImage];
        });
        
    }];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            [self.headerLocationTitle setText:placemark.locality];
        }
        
    }];
    
}

- (void)locationDidFail
{
    // show another image

}

- (void)blurBackgroundImage
{
    UIGraphicsBeginImageContext(self.headerBackgroundImageView.bounds.size);
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, 0);
    [self.headerBackgroundImageView.layer renderInContext:c];
    
    UIImage* blurimage = UIGraphicsGetImageFromCurrentImageContext();
    
    blurimage = [blurimage applyLightEffect];
    
    UIGraphicsEndImageContext();
    
    [self.headerForegroundImageView setImage:blurimage];
}

#pragma mark - swipe gesture

- (IBAction)swipeUp:(id)sender {

    if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        
        [self.parentController scrollToBottom];
        
    }
    
    

}

- (IBAction)swipeDown:(id)sender {
    
    [self.parentController scrollToTop];
    
}

@end
