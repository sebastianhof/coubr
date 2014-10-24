//
//  coubrTypesToImage.h
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface coubrTypesToImage : NSObject

+ (UIImage *)imageForType:(NSString *)type;

+ (UIImage *)imageForCategory:(NSString *)category;

+ (UIImage *)imageForSubcategory:(NSString *)subcategory;

@end
