//
//  StampCard+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StampCard+CRUD.h"

@implementation StampCard (CRUD)

+ (NSFetchRequest *)fetchRequestForStampCardWithId:(NSString *)stampCardId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StampCard"];
    request.predicate = [NSPredicate predicateWithFormat:@"(stampCardId = %@)", stampCardId];
    
    return request;
}

@end
