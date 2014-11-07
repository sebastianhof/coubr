//
//  coubrStoreMapViewController.h
//  coubr
//
//  Created by Sebastian Hof on 21/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "coubrStoreViewController.h"

@interface coubrStoreMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) coubrStoreViewController *parentController;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@end
