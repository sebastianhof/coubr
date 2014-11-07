//
//  coubrCategoryToText.m
//  coubr
//
//  Created by Sebastian Hof on 05/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCategoryToText.h"
#import "coubrLocale.h"

@implementation coubrCategoryToText

+ (NSString *)textFromCategory:(NSString *)category andSubcategory:(NSString *)subcategory {

    if ([category isEqualToString:@"bakery"]) {
        return LOCALE_STORE_CATEGORY_BAKERY;
    } else if ([category isEqualToString:@"bar"]) {
        return LOCALE_STORE_CATEGORY_BAR;
    } else if ([category isEqualToString:@"brewery"]) {
        return LOCALE_STORE_CATEGORY_BREWERY;
    } else if ([category isEqualToString:@"cafe"]) {
        return LOCALE_STORE_CATEGORY_CAFE;
    } else if ([category isEqualToString:@"fastfood"]) {
        return LOCALE_STORE_CATEGORY_FAST_FOOD;
    } else if ([category isEqualToString:@"ice"]) {
       return LOCALE_STORE_CATEGORY_ICE_CREAM;
    } else if ([category isEqualToString:@"restaurant"]) {
        
        if ([subcategory isEqualToString:@"asian"]) {
            return LOCALE_STORE_CATEGORY_RESTAURANT_ASIAN;
        } else if ([subcategory isEqualToString:@"french"]) {
            return LOCALE_STORE_CATEGORY_RESTAURANT_FRENCH;
        } else if ([subcategory isEqualToString:@"german"]) {
            return LOCALE_STORE_CATEGORY_RESTAURANT_GERMAN;
        } else if ([subcategory isEqualToString:@"italian"]) {
            return LOCALE_STORE_CATEGORY_RESTAURANT_ITALIAN;
        } else {
            return LOCALE_STORE_CATEGORY_RESTAURANT;
        }

    } else if ([category isEqualToString:@"winery"] ) {
        return LOCALE_STORE_CATEGORY_WINERY;
    } else {
        return LOCALE_STORE_CATEGORY_NONE;    }
    
}

@end
