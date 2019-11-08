//
//  001-WorktimeParameterReduction.m
//  Worktimer
//
//  Created by Martin Häcker on 07.11.19.
//

#import "001-WorktimeParameterReduction.h"

@implementation WorktimeParameterReduction

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sourceInstance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(NSMigrationManager *)manager
                                              error:(NSError * _Nullable *)error
{
    if ( ! [sourceInstance.entity.name isEqualToString:@"Worktime"])
        return false;
    
    NSDate *date = [sourceInstance primitiveValueForKey:@"date"];
    NSDate *startTime = [sourceInstance primitiveValueForKey:@"startTime"];
    NSDate *endTime = [sourceInstance primitiveValueForKey:@"endTime"];
    NSTimeInterval duration = [endTime timeIntervalSinceDate:startTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *day = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSDateComponents *time = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:startTime];
    day.hour = time.hour;
    day.minute = time.minute;
    day.second = time.second;
    NSDate *startDate = [calendar dateFromComponents:day];
    NSDate *endDate = [startDate dateByAddingTimeInterval:duration];

    NSManagedObject *targetInstance = [NSEntityDescription insertNewObjectForEntityForName:@"Worktime" inManagedObjectContext:manager.destinationContext];
    [targetInstance setValue:startDate forKey:@"startDate"];
    [targetInstance setValue:endDate forKey:@"endDate"];
    
    return true;
}
@end
