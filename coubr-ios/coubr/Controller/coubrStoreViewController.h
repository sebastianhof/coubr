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
#define CouponFetchedResultsControllerDidUpdatedNotification @"CouponFetchedResultsControllerDidUpdatedNotification"

@interface coubrStoreViewController : UIViewController

@property (strong, nonatomic, readonly) NSFetchedResultsController *couponFetchedResultsController;
@property (weak, nonatomic, readonly) Store *store;

@property (nonatomic, strong) NSString *storeId;

@end
