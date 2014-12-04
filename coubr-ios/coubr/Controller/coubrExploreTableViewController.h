//
//  coubrExploreTableViewController.h
//  coubr
//
//  Created by Sebastian Hof on 17/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrExploreViewController.h"

@interface coubrExploreTableViewController : UITableViewController <coubrStoreViewDelegate>

@property (weak, nonatomic) coubrExploreViewController *parentController;

- (void)scrollToTop;
- (void)scrollToOffset;

@end
