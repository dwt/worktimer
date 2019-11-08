//  Created by Martin Häcker on 12.02.06.
//  Copyright 2006 M-Soft, IT-Dienste. All rights reserved.

#import "Worktime.h"
#import "TimeComputation.h"
#import "Worktimer_AppDelegate.h"

@implementation Worktime

// FIXME need to ensure that the endDate is always on the same day as the startDate

// REFACT: change internal time-format to be a full date
// This would need additional GUI!
// REFACT consider to fix the date on both start and end time to the date that is displayed on the left
// that should make the time computation much easier (and it should also be a computed value, that is expressed as a NSTimeInterval oder NSDateInterval
// then format with NSDateIntervalFormatter mit .timeStyle = NSDateIntervalFormatterShortStyle
// this should have a project / tag, that is auto-selected to the lasts entry tag
// consider to have an easy text entry box, that allows you to enter lines like this: '@sntl', and then starts a line for sntl right now
// I want a weekly commitment, that the app shows when it is reached
// it should also compute and show the overtime
// it could help by adding pomodoros, so it is easier to plan how many pomodoros you invest in a task and then run the timers
// needs to be able to tell the app that a day is 'free' because of feiertag or holiday
// app should track number of holidays and display that
// could show work-time / remaining daily time in the touch bar
// would be really cool, if I could edit the duration, to change the end-time
// for each project, store till when it is billed / and display not billed hours?
// store project hourly rate and display income?

// Formulate migration strategy and what can be done as lightweight migrations

// This model should have two values, start / end.
// Every other value should be derived from these.
// Add automatism that sets the date part of the end time to the date of the start time
/*
 Likely steps to achieve this
 - Follow https://medium.com/@shakya4577/heavyweight-core-data-migration-51570555124b
 - example code: https://github.com/shakya4577/HeavyweightMigration
 - Create second model version that has only the new values start / end (maybe startDate/ endDate)
 - Create MappingModel
 - Map startDate from date+startTime
 - Map endDate from date+endTime
 - Provide methods that still return the old named values
 - with change notifications so the ui can auto update
 - provide method that retuns the date components
 - display the date components with a NSDateComponentsFormatter in the UI
 - update ui to display start / end directly with NSDateFormatter
 */

/*
 - later: consider how to update the endDate from changes to those date components
 - add new field company / tag / job that signifies the company / the job is done for
    - consider a compound field that combines job@company sntl@work, sntl@sprint or the other way around?
    - this could emulate sntl@sick, sntl@holiday to add special time entries that cover for special time
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

// REFACT need to transform this to NSDuration or something similar, so key value bindings can sum them
// then transform that to a string with a value transformer on the NSTextField that displays it
- (NSString *) hoursAndMinutesFromDuration {
	return [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:[self duration]];
}

// REFACT should be setStartDate
- (void)setStartDate:(NSDate *)newDate {
    [self willChangeValueForKey: @"startDate"];
    [self setPrimitiveValue: newDate forKey: @"startDate"];
    [self didChangeValueForKey: @"startDate"];
    [(Worktimer_AppDelegate *)[NSApp delegate] refreshSorting];
}

- (void)setEndDate:(NSDate *)newDate {
    NSDate *startDate = [self primitiveValueForKey:@"startDate"];
    newDate = [self forceDate:newDate toSameDayAsDate:startDate];
    
    [self willChangeValueForKey: @"endDate"];
    [self setPrimitiveValue: newDate forKey: @"endDate"];
    [self didChangeValueForKey: @"endDate"];
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
