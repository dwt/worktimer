//
//  Created by Martin Häcker on 28.04.10.
//  Copyright 2010 DWTs Heavy Industries. All rights reserved.
//

#import "TimeComputation.h"


// REFACT: make instance method
NSString *stringFromTimeInterval(NSTimeInterval duration) {
	duration = fabs(duration); // want to always format as positive interval
	const int SECONDS_IN_HOUR = 60 * 60;
	const int MINUTES_IN_HOUR = 60;
    
    int hours = (int)duration / SECONDS_IN_HOUR;
    int minutes = ((int)duration - hours * SECONDS_IN_HOUR) / MINUTES_IN_HOUR;
    return [NSString stringWithFormat: @"%d:%02d", hours, minutes];
}

@implementation TimeComputation

+ (TimeComputation *) sharedInstance {
	static id instance = nil;
	if ( ! instance)
		instance = [[self alloc] init];
	return instance;
}

- (NSDate *)timeFromDate:(NSDate *)aDate {
	// REFACT: find a better way to represent the time
	// hack that leaves all fields except hours and minutes empty
    id timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [timeFormatter setDateFormat: @"%H:%M"];
    return [timeFormatter dateFromString: [timeFormatter stringFromDate:aDate]];
}

- (NSDate *)currentTime {
	return [self timeFromDate:[NSDate date]];
}

- (NSString *)hoursAndMinutesFromInterval: (NSTimeInterval) duration; {
    return stringFromTimeInterval(duration);
}

@end
