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

+ (NSString *)textFromStoreCategory:(NSString *)category andStoreSubcategory:(NSString *)subcategory {

    // Store
    
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

+ (NSString *)textFromCouponCategory:(NSString *)category
{
    return LOCALE_COUPON_CATEGORY_NONE;
}

+ (NSString *)textFromSpecialOfferCategory:(NSString *)category
{
    if ([category isEqualToString:@"daily"]) {
        return LOCALE_SPECIAL_OFFER_CATEGORY_DAILY;
    } else if ([category isEqualToString:@"weekly"]) {
        return LOCALE_SPECIAL_OFFER_CATEGORY_WEEKLY;
    } else if ([category isEqualToString:@"monthly"]) {
        return LOCALE_SPECIAL_OFFER_CATEGORY_MONTHLY;
    } else if ([category isEqualToString:@"happyhour"]) {
        return LOCALE_SPECIAL_OFFER_CATEGORY_HAPPYHOUR;
    } else {
        return LOCALE_SPECIAL_OFFER_CATEGORY_NONE;
    }
}

+ (NSString *)textFromStampCardCategory:(NSString *)category
{
    return LOCALE_STAMP_CARD_CATEGORY_NONE;
}

@end
