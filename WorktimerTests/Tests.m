#import <XCTest/XCTest.h>

#import "Worktime.h"
#import "TimeComputation.h"

@interface Tests : XCTestCase {
    id model, coordinator, context;
    id timeComputation;
}
@end

@implementation Tests

- (void) setUp {
	model = [NSManagedObjectModel mergedModelFromBundles:nil]; // Autoreleased!
	coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	[context setPersistentStoreCoordinator:coordinator];
	
	timeComputation = [[TimeComputation alloc] init];
}

- (void) tearDown {
}

- createWorktime { return [NSEntityDescription insertNewObjectForEntityForName:@"Worktime" inManagedObjectContext:context]; }

- (void) testCreateAndWorkWithAWorktime
{
	id worktime = [self createWorktime];
	id endTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*4]];
	
	[worktime setValue: endTime forKey: @"endTime"];
	
	XCTAssertEqualObjects(@"0:04", [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:[[worktime valueForKey:@"endTime"] timeIntervalSinceDate:[worktime valueForKey:@"startTime"]]]);
}

- (void) testWorktimeKnowsItsWorktimeIfEndTimeSpecified
{
	id worktime = [self createWorktime];
	id endTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*4]];
	[worktime setValue: endTime forKey: @"endTime"];
	
	XCTAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration]);
}

- (void) testWorktimeAssumesWorktimeTillNowIfEndTimeNotSpecified
{
	id worktime = [self createWorktime];
	id startTime = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:-60*4]];
	[worktime setValue:startTime forKey:@"startTime"];
	XCTAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration]);
}

- (void) donttestComputingTheTotalWorktimeOfOneDay
{
	
}

- (void) donttestContinuallyUpdateWorktimeAsLongAsEndDateIsNotSet
{
	id worktime = [self createWorktime];
	id startTime = [timeComputation timeFromDate:[NSDate dateWithTimeIntervalSinceNow:-37]];
	[worktime setValue:startTime forKey:@"startTime"];
	XCTAssertEqualObjects(@"0:00", [worktime hoursAndMinutesFromDuration], @"before sleep");
	sleep(1);
	XCTAssertEqualObjects(@"0:01", [worktime hoursAndMinutesFromDuration], @"after sleep");
}

@end
