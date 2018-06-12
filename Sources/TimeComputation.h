//
//  Created by Martin Häcker on 28.04.10.
//  Copyright 2010 DWTs Heavy Industries. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSString *stringFromTimeInterval(NSTimeInterval duration);

@interface TimeComputation : NSObject

+ (TimeComputation *) sharedInstance;

- (NSDate *)timeFromDate:(NSDate *)aDate;
- (NSDate *)currentTime;

- (NSString *)hoursAndMinutesFromInterval:(NSTimeInterval)duration;

@end
