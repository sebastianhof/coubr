//
//  coubrExploreFilterCategoryCollectionViewCell.h
//  coubr
//
//  Created by Sebastian Hof on 17/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coubrExploreFilterViewController.h"

@interface coubrExploreFilterCategoryCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) NSString *category;
@property (weak, nonatomic)coubrExploreFilterViewController *parentController;

@end
