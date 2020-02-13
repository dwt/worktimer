//
//  NSTimeIntervalFormatterr.m
//  Worktimer
//
//  Created by Martin Häcker on 23.04.20.
//

#import "TimeIntervalFormatter.h"
#import "TimeComputation.h"

@implementation TimeIntervalFormatter

- (NSString *)stringForObjectValue:(id)value
{
    // REFACT probably should move the full computation from TimeComputation here
    return [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:[value doubleValue]];
}

- (BOOL)getObjectValue:(out __autoreleasing id *)obj forString:(NSString *)string errorDescription:(out NSString *__autoreleasing *)error;
{
    // not implemented
    return false;
}
@end
