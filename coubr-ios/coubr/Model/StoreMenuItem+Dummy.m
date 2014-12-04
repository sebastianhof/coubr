//
//  StoreMenuItem+Dummy.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreMenuItem+Dummy.h"
#import "coubrConstants.h"

@implementation StoreMenuItem (Dummy)

+ (NSArray *)menuCategories
{
    NSMutableArray *menuCategories = [[NSMutableArray alloc] init];
    
    NSDictionary *starterDict = @{
          STORE_RESPONSE_MENU_CATEGORY: @"Vorspeise",
          STORE_RESPONSE_MENU_ITEMS: [self starterItems]
                                  };
    
    [menuCategories addObject:starterDict];
    
    NSDictionary *mainDict = @{
                                  STORE_RESPONSE_MENU_CATEGORY: @"Hauptspeise",
                                  STORE_RESPONSE_MENU_ITEMS: [self mainItems]
                                  };
    
    [menuCategories addObject:mainDict];
    
    NSDictionary *desertDict = @{
                                  STORE_RESPONSE_MENU_CATEGORY: @"Nachspeise",
                                  STORE_RESPONSE_MENU_ITEMS: [self desertItems]
                                  };
    
    [menuCategories addObject:desertDict];
    
    return menuCategories;
}

+ (NSArray *)starterItems
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];

    for (int i = 0; i < 5; i++) {
        
        NSDictionary *menuItemDictionary = @{
                                            
                STORE_RESPONSE_MENU_ITEM_TITLE: [NSString stringWithFormat:@"Vorspeise %i", i + 1],
                STORE_RESPONSE_MENU_ITEM_RANK: [NSNumber numberWithInt:i],
                STORE_RESPONSE_MENU_ITEM_PRICE: [NSNumber numberWithDouble:3.00]
            
                                            };
        [menuItems addObject:menuItemDictionary];

    }
    
    return menuItems;
}

+ (NSArray *)mainItems
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    
    for (int i = 10; i < 20; i++) {
        
        NSDictionary *menuItemDictionary = @{
                                             
                 STORE_RESPONSE_MENU_ITEM_TITLE: [NSString stringWithFormat:@"Hauptspeise %i", i + 1],
                 STORE_RESPONSE_MENU_ITEM_RANK: [NSNumber numberWithInt:i],
                 STORE_RESPONSE_MENU_ITEM_PRICE: [NSNumber numberWithDouble:10.00]
                 
                                             
                                             };
        [menuItems addObject:menuItemDictionary];
        
    }
    
    return menuItems;
}
    
+ (NSArray *)desertItems
{
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];

    for (int i = 20; i < 23; i++) {
        
        NSDictionary *menuItemDictionary = @{
                                             
                 STORE_RESPONSE_MENU_ITEM_TITLE: [NSString stringWithFormat:@"Nachspeise %i", i + 1],
                 STORE_RESPONSE_MENU_ITEM_RANK: [NSNumber numberWithInt:i],
                 STORE_RESPONSE_MENU_ITEM_PRICE: [NSNumber numberWithDouble:4.00]
                                             
                                             };
        [menuItems addObject:menuItemDictionary];
        
    }
    
    return menuItems;
}

@end
