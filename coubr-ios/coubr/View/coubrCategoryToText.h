//
//  coubrCategoryToText.h
//  coubr
//
//  Created by Sebastian Hof on 05/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface coubrCategoryToText : NSObject

+ (NSString *)textFromStoreCategory:(NSString *)category andStoreSubcategory:(NSString *)subcategory;

+ (NSString *)textFromCouponCategory:(NSString *)category;

+ (NSString *)textFromStampCardCategory:(NSString *)category;

+ (NSString *)textFromSpecialOfferCategory:(NSString *)category;

@end
