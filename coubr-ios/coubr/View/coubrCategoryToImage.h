//
//  coubrCategoryToImage.h
//  coubr
//
//  Created by Sebastian Hof on 17/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coubrCategoryToImage : UIView

+ (UIImage *)imageForCategory:(NSString *)category;

+ (UIImage *)imageForSubcategory:(NSString *)subcategory;

@end
