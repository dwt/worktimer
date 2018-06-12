#import "Tests.h"
#import "Worktime.h"
#import "TimeComputation.h"


@implementation Tests

- (void) setUp {
	model = [NSManagedObjectModel mergedModelFromBundles:nil]; // Autoreleased!
	coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	context = [[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:coordinator];
	
	timeComputation = [[TimeComputation alloc] init];
}

- (void) tearDown {
	[context release];
	[coordinator release];
}

- createWorktime { return [NSEntityDescription insertNewObjectForEntityForName:@"Worktime" inManagedObjectContext:context]; }

- (void) testCreateAndWorkWithAWorktime
{
	id worktime = [self createWorktime];
	id endTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*4]];
	
	[worktime setValue: endTime forKey: @"endTime"];
	
	STAssertEqualObjects(@"0:04", [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:[[worktime valueForKey:@"endTime"] timeIntervalSinceDate:[worktime valueForKey:@"startTime"]]], nil);
}

- (void) testWorktimeKnowsItsWorktimeIfEndTimeSpecified
{
	id worktime = [self createWorktime];
	id endTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*4]];
	[worktime setValue: endTime forKey: @"endTime"];
	
	STAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration], nil);
}

- (void) testWorktimeAssumesWorktimeTillNowIfEndTimeNotSpecified
{
	id worktime = [self createWorktime];
	id startTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:-60*4]];
	[worktime setValue:startTime forKey:@"startTime"];
	STAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration], nil);
}

- (void) donttestComputingTheTotalWorktimeOfOneDay
{
	
}

- (void) donttestContinuallyUpdateWorktimeAsLongAsEndDateIsNotSet
{
	id worktime = [self createWorktime];
	id startTime = [timeComputation timeFromDate:[NSDate dateWithTimeIntervalSinceNow:-37]];
	[worktime setValue:startTime forKey:@"startTime"];
	STAssertEqualObjects(@"0:00", [worktime hoursAndMinutesFromDuration], @"before sleep");
	sleep(1);
	STAssertEqualObjects(@"0:01", [worktime hoursAndMinutesFromDuration], @"after sleep");
}

@end
