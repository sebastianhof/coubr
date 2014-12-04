//
//  Store+Distance.m
//  coubr
//
//  Created by Sebastian Hof on 21/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "Store+Distance.h"
#import "coubrLocale.h"

#import <MapKit/MapKit.h>

@implementation Store (Distance)

#define MILES_IN_METER 1609.344
#define FEET_IN_METER 0.3048

- (NSString *)distanceSection
{
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    [distanceFormatter setLocale:[NSLocale currentLocale]];
    [distanceFormatter setUnitStyle:MKDistanceFormatterUnitStyleFull];
 
    double distance = [[self distance] doubleValue];
    
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue]) {
        
        if (distance < 200) {
            return LOCALE_EXPLORE_NEARBY_HEADER;
        } else if (distance < 500) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:200.0]];
        } else if (distance < 1000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:500.0]];
        } else if (distance < 2000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:1000.0]];
        } else if (distance < 5000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:2000.0]];
        } else if (distance < 10000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:5000.0]];
        } else if (distance < 20000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:10000.0]];
        } else if (distance < 50000) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:20000.0]];
        } else {
            return LOCALE_EXPLORE_FAR_AWAY_HEADER;
        }
        
    } else {
        
        if ((distance / MILES_IN_METER) < 0.1) {
            return LOCALE_EXPLORE_NEARBY_HEADER;
        } else if ((distance / MILES_IN_METER) < 0.2) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(0.1 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 0.5) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(0.2 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 1) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(0.5 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 2) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(1 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 5) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(2 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 10) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(5 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 20) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(10 * MILES_IN_METER)]];
        } else if ((distance / MILES_IN_METER) < 50) {
            return [NSString stringWithFormat:@"%@ %@", LOCALE_EXPLORE_IN_HEADER, [distanceFormatter stringFromDistance:(20 * MILES_IN_METER)]];
        } else {
            return LOCALE_EXPLORE_FAR_AWAY_HEADER;
        }
        
    }
    
}

@end
