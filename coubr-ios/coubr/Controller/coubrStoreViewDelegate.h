//
//  coubrStoreViewDelegate.h
//  coubr
//
//  Created by Sebastian Hof on 17/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol coubrStoreViewDelegate <NSObject>

@required
@property (strong, nonatomic, readonly) NSMutableArray *storeIds;

@end
