//
//  coubrExploreViewController.h
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#define FetchedResultsControllerDidUpdatedNotification @"FetchedResultsControllerDidUpdatedNotification"

@interface coubrExploreViewController : UIViewController 

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)refresh;

@end
