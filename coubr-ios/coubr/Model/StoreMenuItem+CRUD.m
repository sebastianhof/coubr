//
//  StoreMenuItem+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StoreMenuItem+CRUD.h"

#import "coubrUtil.h"
#import "coubrConstants.h"
#import "coubrDatabaseManager.h"

@implementation StoreMenuItem (CRUD)

+ (NSFetchRequest *)fetchRequestForMeunItemsOfStoreWithId:(NSString *)storeId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StoreMenuItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"(store.storeId = %@)", storeId];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES] ];
    return request;
}

+ (void)insertStoreMenuItemsToStore:(Store *)store categories:(NSArray *)categories
{
    NSManagedObjectContext *context = [[coubrDatabaseManager defaultManager] managedObjectContext];
    
    for (NSDictionary *categoryDict in categories) {
        
        NSString *category = isValidJSONValue(categoryDict[STORE_RESPONSE_MENU_CATEGORY]) ? categoryDict[STORE_RESPONSE_MENU_CATEGORY] : nil;
        if (category) {
            
            NSArray *menuItems = isValidJSONValue(categoryDict[STORE_RESPONSE_MENU_ITEMS]) ? categoryDict[STORE_RESPONSE_MENU_ITEMS] : nil;
            
            for (NSDictionary* menuItemJSON in menuItems) {
                
                StoreMenuItem *menuItem = [NSEntityDescription insertNewObjectForEntityForName:@"StoreMenuItem" inManagedObjectContext:context];
                
                menuItem.title = isValidJSONValue(menuItemJSON[STORE_RESPONSE_MENU_ITEM_TITLE]) ? menuItemJSON[STORE_RESPONSE_MENU_ITEM_TITLE] : nil;
                menuItem.category = category;
                menuItem.rank = isValidJSONValue(menuItemJSON[STORE_RESPONSE_MENU_ITEM_RANK]) ? menuItemJSON[STORE_RESPONSE_MENU_ITEM_RANK] : nil;
                menuItem.price = isValidJSONValue(menuItemJSON[STORE_RESPONSE_MENU_ITEM_PRICE]) ? menuItemJSON[STORE_RESPONSE_MENU_ITEM_PRICE] : nil;
                menuItem.store = store;
                
            }
            
        }
        
    }
    
}

@end
