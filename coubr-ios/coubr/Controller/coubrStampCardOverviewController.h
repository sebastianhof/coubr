//
//  coubrStampCardOverviewController.h
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StampCard.h"

@interface coubrStampCardOverviewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) StampCard *stampCard;

@end
