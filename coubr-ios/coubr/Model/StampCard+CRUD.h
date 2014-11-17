//
//  StampCard+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "StampCard.h"

@interface StampCard (CRUD)

+ (NSFetchRequest *)fetchRequestForStampCardWithId:(NSString *)stampCardId;

@end
