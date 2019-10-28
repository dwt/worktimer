//  Created by Martin Häcker on 12.02.06.
//  Copyright 2006 M-Soft, IT-Dienste. All rights reserved.

#import "Worktime.h"
#import "TimeComputation.h"
#import "Worktimer_AppDelegate.h"

@implementation Worktime 

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

- (void) awakeFromInsert {
	[self setPrimitiveValue: [NSDate date] forKey: @"date"];
    [self setPrimitiveValue: [[TimeComputation sharedInstance] currentTime] forKey: @"startTime"];
}

+ (NSSet *)keyPathsForValuesAffectingdurationAsHoursAndMinutes {
	return [NSSet setWithObjects:@"startTime", @"endTime", nil];
}

// REFACT need to transform this to NSDuration or something similar, so key value bindings can sum them
// then transform that to a string with a value transformer on the NSTextField that displays it
- (NSString *)hoursAndMinutesFromDuration; {
	NSTimeInterval duration = 0;
	if ([self valueForKey:@"endTime"])
		duration = [[self valueForKey:@"endTime"] timeIntervalSinceDate: [self valueForKey:@"startTime"]];
	else
		duration = [[[TimeComputation sharedInstance] currentTime] timeIntervalSinceDate: [self valueForKey:@"startTime"]];
	
	return [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:duration];
}

// REFACT: figure out how to get rid of this legacy symbol.
- (NSString *)durationAsHoursAndMinutes { return [self hoursAndMinutesFromDuration]; }


- (void)setDate:(NSDate *)value 
{
    [self willChangeValueForKey: @"date"];
    [self setPrimitiveValue: value forKey: @"date"];
    [self didChangeValueForKey: @"date"];
    [(Worktimer_AppDelegate *)[NSApp delegate] refreshSorting];
}

@end
