//
//  SpecialOffer+CRUD.m
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "SpecialOffer+CRUD.h"

@implementation SpecialOffer (CRUD)

+ (NSFetchRequest *)fetchRequestForSpecialOfferWithId:(NSString *)specialOfferId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SpecialOffer"];
    request.predicate = [NSPredicate predicateWithFormat:@"(specialOfferId = %@)", specialOfferId];
    
    return request;
}

@end
