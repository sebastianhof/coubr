//
//  coubrSpecialOfferOverviewController.h
//  coubr
//
//  Created by Sebastian Hof on 12/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialOffer.h"

@interface coubrSpecialOfferOverviewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) SpecialOffer *specialOffer;

@end
