//
//  coubrCategoryToImage.m
//  coubr
//
//  Created by Sebastian Hof on 17/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrCategoryToImage.h"

@implementation coubrCategoryToImage

+ (UIImage *)imageForCategory:(NSString *)category
{
    UIImage *image;
    
    if ([category isEqualToString:@"bakery"]) {
        image =  [UIImage imageNamed:@"Explore_Category_Bread"];
    } else if ([category isEqualToString:@"bar"]) {
        image = [UIImage imageNamed:@"Explore_Category_Bar"];
    } else if ([category isEqualToString:@"brewery"]) {
        image = [UIImage imageNamed:@"Explore_Category_Brewery"];
    } else if ([category isEqualToString:@"cafe"]) {
        image = [UIImage imageNamed:@"Explore_Category_Cafe"];
    } else if ([category isEqualToString:@"fastfood"]) {
        image = [UIImage imageNamed:@"Explore_Category_Fastfood"];
    } else if ([category isEqualToString:@"ice"]) {
        image = [UIImage imageNamed:@"Explore_Category_IceCream"];
    } else if ([category isEqualToString:@"restaurant"]) {
        image = [UIImage imageNamed:@"Explore_Category_Restaurant"];
    } else if ([category isEqualToString:@"winery"] ) {
        image = [UIImage imageNamed:@"Explore_Category_Winery"];
    } else {
        return nil;
    }
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)imageForSubcategory:(NSString *)subcategory
{
//    UIImage *image;
//    
//    if ([subcategory isEqualToString:@"asian"]) {
//        image = [UIImage imageNamed:@"057_Sushi"];
//    } else if ([subcategory isEqualToString:@"french"]) {
//        image = [UIImage imageNamed:@"051_Croisant"];
//    } else if ([subcategory isEqualToString:@"german"]) {
//        image = [UIImage imageNamed:@"069_Sausage"];
//    } else if ([subcategory isEqualToString:@"italian"]) {
//        image = [UIImage imageNamed:@"061_Pasta"];
//    } else {
//        return nil;
//    }
//    
//    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return nil;
}


@end
