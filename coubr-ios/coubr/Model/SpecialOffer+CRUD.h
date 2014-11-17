//
//  SpecialOffer+CRUD.h
//  coubr
//
//  Created by Sebastian Hof on 08/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "SpecialOffer.h"

@interface SpecialOffer (CRUD)

+ (NSFetchRequest *)fetchRequestForSpecialOfferWithId:(NSString *)specialOfferId;

@end
