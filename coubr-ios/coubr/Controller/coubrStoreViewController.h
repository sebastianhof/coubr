//
//  coubrStoreViewController.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import "Store.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define StoreDidBecomeAvailableNotification @"StoreDidBecomeAvailableNotification"
#define STORE_ID @"StoreId"
#define STORE @"Store"

@interface coubrStoreViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) NSString *storeId;

@end
