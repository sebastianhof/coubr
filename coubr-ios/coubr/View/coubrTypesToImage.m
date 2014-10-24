//
//  coubrTypesToImage.m
//  coubr
//
//  Created by Sebastian Hof on 20/10/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrTypesToImage.h"

@implementation coubrTypesToImage

+ (UIImage *)imageForType:(NSString *)type
{
    UIImage *image;
    
    if ([type isEqualToString:@"food"]) {
        image = [UIImage imageNamed:@"001_Bone"];
    } else {
        return nil;
    }
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)imageForCategory:(NSString *)category
{
    UIImage *image;
    
    if ([category isEqualToString:@"bakery"]) {
        image =  [UIImage imageNamed:@"006_Bread"];
    } else if ([category isEqualToString:@"bar"]) {
       image = [UIImage imageNamed:@"075_Cocktail"];
    } else if ([category isEqualToString:@"brewery"]) {
        image = [UIImage imageNamed:@"071_Beer"];
    } else if ([category isEqualToString:@"cafe"]) {
        image = [UIImage imageNamed:@"015_Coffee_Bean"];
    } else if ([category isEqualToString:@"fastfood"]) {
        image = [UIImage imageNamed:@"063_Hamburger"];
    } else if ([category isEqualToString:@"ice"]) {
        image = [UIImage imageNamed:@"056_IceCream"];
    } else if ([category isEqualToString:@"restaurant"]) {
        image = [UIImage imageNamed:@"001_Bone"];
    } else if ([category isEqualToString:@"winery"] ) {
        image = [UIImage imageNamed:@"040_WineRed"];
    } else {
        return nil;
    }
                  
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)imageForSubcategory:(NSString *)subcategory
{
    UIImage *image;
    
    if ([subcategory isEqualToString:@"asian"]) {
        image = [UIImage imageNamed:@"057_Sushi"];
    } else if ([subcategory isEqualToString:@"french"]) {
        image = [UIImage imageNamed:@"051_Croisant"];
    } else if ([subcategory isEqualToString:@"german"]) {
        image = [UIImage imageNamed:@"069_Sausage"];
    } else if ([subcategory isEqualToString:@"italian"]) {
        image = [UIImage imageNamed:@"061_Pasta"];
    } else {
        return nil;
    }
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
