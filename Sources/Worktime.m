//  Created by Martin Häcker on 12.02.06.
//  Copyright 2006 M-Soft, IT-Dienste. All rights reserved.

#import "Worktime.h"
#import "TimeComputation.h"
#import "Worktimer_AppDelegate.h"

@implementation Worktime 

// REFACT: change internal time-format to be a full date
// This would need additional GUI!

- (void) awakeFromInsert {
	[self setPrimitiveValue: [NSDate date] forKey: @"date"];
    [self setPrimitiveValue: [[TimeComputation sharedInstance] currentTime] forKey: @"startTime"];
}

+ (NSSet *)keyPathsForValuesAffectingdurationAsHoursAndMinutes {
	return [NSSet setWithObjects:@"startTime", @"endTime", nil];
}

- (NSString *)hoursAndMinutesFromDuration; {
	NSTimeInterval duration = 0;
	if ([self valueForKey:@"endTime"])
		duration = [[self valueForKey:@"endTime"] timeIntervalSinceDate: [self valueForKey:@"startTime"]];
	else
		duration = [[[TimeComputation sharedInstance] currentTime] timeIntervalSinceDate: [self valueForKey:@"startTime"]];
	
	return [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:duration];
}

// REFACT need to transform this to NSDuration or something similar, so key value bindings can sum them
// then transform that to a string with a value transformer on the NSTextField that displays it
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
