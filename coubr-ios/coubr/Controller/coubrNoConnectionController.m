//
//  coubrNoConnectionController.m
//  coubr
//
//  Created by Sebastian Hof on 20/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "coubrNoConnectionController.h"
#import "coubrConstants.h"

@implementation coubrNoConnectionController

- (IBAction)serverStatus:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:STATUS_URL]];
}

@end
