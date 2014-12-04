//
//  coubrExploreViewController.h
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "coubrStoreViewDelegate.h"

#define FetchedResultsControllerDidUpdatedNotification @"FetchedResultsControllerDidUpdatedNotification"

#define ConnectionDidFailNotification @"ConnectionDidFailNotification"
#define ConnectionDidBecomeAvailableNotification @"ConnectionDidBecomeAvailableNotification"

@interface coubrExploreViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)updateFetchedResultsController;

- (void)updateFetchedResultsControllerRequest;

- (void)setSelectedStoreToIndex:(NSInteger)index;

@property (nonatomic, readonly) BOOL showsMapInFullscreen;

@end
