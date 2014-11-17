//
//  coubrExploreFilterViewController.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrExploreViewController.h"

@interface coubrExploreFilterViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) coubrExploreViewController *parentController;

@property (nonatomic, readonly) float currentDistance;

@property (nonatomic, readonly) BOOL showSpecialOffers;
@property (nonatomic, readonly) BOOL showStampCards;
@property (nonatomic, readonly) BOOL showCoupons;

@property (strong, nonatomic, readonly) NSMutableSet *selectedCategories;
@property (strong, nonatomic, readonly) NSMutableSet *selectedSubcategories;

- (void)addCategory:(NSString *)category;
- (void)removeCategory:(NSString *)category;

@end
