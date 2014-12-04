//
//  coubrNoStoreController.m
//  coubr
//
//  Created by Sebastian Hof on 20/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrNoStoreController.h"

@implementation coubrNoStoreController

- (IBAction)searchAnotherLocation:(id)sender {
    [self.parentController.parentController.searchController setActive:YES];
}

@end
