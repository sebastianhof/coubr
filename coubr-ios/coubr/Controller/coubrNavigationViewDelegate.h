//
//  coubrNavigationViewDelegate.h
//  coubr
//
//  Created by Sebastian Hof on 15.10.14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#ifndef coubr_coubrNavigationViewDelegate_h
#define coubr_coubrNavigationViewDelegate_h

#endif

#import <Foundation/Foundation.h>

@protocol coubrNavigationViewDelegate <NSObject>

@required
-(void)hideNavigationViewInMainView;
-(void)showNavigationViewInMainView;

-(void)showExploreViewInMainView;
-(void)showProfileViewInMainView;
-(void)showSettingsViewInMainView;

@end