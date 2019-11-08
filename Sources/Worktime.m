//  Created by Martin Häcker on 12.02.06.
//  Copyright 2006 M-Soft, IT-Dienste. All rights reserved.

#import "Worktime.h"
#import "TimeComputation.h"
#import "Worktimer_AppDelegate.h"

@implementation Worktime

/*
REFACT
Consider adding a project / tag, that is auto-selected to the lasts entry tag
Consider to have an easy text entry box, that allows you to enter lines like this: '@sntl', and then starts a line for sntl right now
I want a weekly commitment per customer, that the app shows when it is reached
This allows the app to compute and show the overtime
Consider adding the pomodoro-timer in line and using it to plan the day for different tasks
needs to be able to tell the app that a day is 'free' because of feiertag or holiday
app should track number of holidays and display that
could show work-time / remaining daily time in the touch bar
would be really cool, if I could edit the duration, to change the end-time
for each project, store till when it is billed / and display not billed hours?
consider a compound field that combines job@company sntl@work, sntl@sprint or the other way around?
this could emulate sntl@sick, sntl@holiday to add special time entries that cover for special time
*/

/*
 CoreDatea Migrations howto:
 - Example (Swift) https://medium.com/@shakya4577/heavyweight-core-data-migration-51570555124b
 - Example code https://github.com/shakya4577/HeavyweightMigration
 - Example ObjC https://www.objc.io/issues/4-core-data/core-data-migration/#progressive-migrations
 */

- (void) awakeFromInsert {
	[self setPrimitiveValue: [NSDate date] forKey: @"startDate"];
}

+ (NSSet *) keyPathsForValuesAffectingdurationAsHoursAndMinutes {
	return [NSSet setWithObjects:@"startDate", @"endDate", nil];
}

- (NSTimeInterval) duration {
    NSDate *startDate = [self valueForKey:@"startDate"];
    NSDate *endDate = [self valueForKey:@"endDate"];
    
    if ( ! endDate) {
        endDate = [self forceDate:[NSDate date] toSameDayAsDate:startDate];
    }

    return [endDate timeIntervalSinceDate:startDate];
}

- (NSString *) hoursAndMinutesFromDuration {
	return [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:[self duration]];
}

- (void)setStartDate:(NSDate *)newDate {
    [self willChangeValueForKey:@"startDate"];
    [self setPrimitiveValue:newDate forKey:@"startDate"];
    [self didChangeValueForKey:@"startDate"];
    [(Worktimer_AppDelegate *)[NSApp delegate] refreshSorting];
}

- (void)setEndDate:(NSDate *)newDate {
    NSDate *startDate = [self primitiveValueForKey:@"startDate"];
    newDate = [self forceDate:newDate toSameDayAsDate:startDate];
    
    [self willChangeValueForKey:@"endDate"];
    [self setPrimitiveValue:newDate forKey:@"endDate"];
    [self didChangeValueForKey:@"endDate"];
}

- (NSDate *)forceDate:(NSDate *)aDate toSameDayAsDate:(NSDate *)referenceDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *referenceDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:referenceDate];
    NSDateComponents *endDateComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate];
    
    endDateComponents.year = referenceDateComponents.year;
    endDateComponents.month = referenceDateComponents.month;
    endDateComponents.day = referenceDateComponents.day;
    
    return [calendar dateFromComponents:endDateComponents];
}

@end
