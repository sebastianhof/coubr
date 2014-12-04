//
//  History+Date.m
//  coubr
//
//  Created by Sebastian Hof on 22/11/14.
//  Copyright (c) 2014 coubr. All rights reserved.
//

#import "History+Date.h"
#import "coubrLocale.h"

@implementation History (Date)

- (NSString *)dateSection
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                fromDate:now];
    
    NSDate *today = [calendar dateFromComponents:dayComponents];
    
    [dayComponents setDay:dayComponents.day - 1];
     NSDate *yesterday = [calendar dateFromComponents:dayComponents];
    
    NSDateComponents *monthComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:now];
    NSDate *thisMonth = [calendar dateFromComponents:monthComponents];
    
    [monthComponents setMonth:monthComponents.month -1];
    NSDate *lastMonth = [calendar dateFromComponents:monthComponents];
    
    NSDateComponents *yearComponents = [calendar components:NSYearCalendarUnit fromDate:now];
    NSDate *thisYear = [calendar dateFromComponents:yearComponents];
    
    [yearComponents setYear:yearComponents.year -1];
    NSDate *lastYear = [calendar dateFromComponents:yearComponents];

    NSLog(@"%@", self.date);
    
    if ([self.date compare:today] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_TODAY;
    }
    
    if ([self.date compare:yesterday] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_YESTERDAY;
    }
    
    if ([self.date compare:thisMonth] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_THIS_MONTH;
    }
    
    if ([self.date compare:lastMonth] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_LAST_MONTH;
    }
    
    if ([self.date compare:thisYear] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_THIS_YEAR;
    }
    
    if ([self.date compare:lastYear] == NSOrderedDescending) {
        return LOCALE_HISTORY_DATE_LAST_YEAR;
    }
    
    return LOCALE_HISTORY_DATE_LONG_TIME_AGO;
}

@end
