//
//  coubrStoreMenuTableViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreMenuItem.h"

@interface coubrStoreMenuTableViewCell : UITableViewCell

- (void)initCellWithStoreMenuItem:(StoreMenuItem *)menuItem;

@end
