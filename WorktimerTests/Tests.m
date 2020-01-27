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

- (void) testWorktimeKnowsItsWorktimeIfEndTimeSpecified {
	id worktime = [self createWorktime];
	id endDate = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*5]];
	[worktime setValue: endDate forKey: @"endDate"];
	XCTAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration]);
}

- (void) testWorktimeAssumesWorktimeTillNowIfEndTimeNotSpecified {
	id worktime = [self createWorktime];
	id startDate = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:-60*4]];
	[worktime setValue:startDate forKey:@"startDate"];
	XCTAssertEqualObjects(@"0:04", [worktime hoursAndMinutesFromDuration]);
}

- (void) testForcesEndDateToSameDayAsStartDate {
    id worktime = [self createWorktime];
    id startDate = [worktime valueForKey:@"startDate"];
    id endDate = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*24*3]];
    [worktime setValue:endDate forKey:@"endDate"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    XCTAssertNotEqual(
        [calendar component:NSCalendarUnitDay fromDate:startDate],
        [calendar component:NSCalendarUnitDay fromDate:endDate]
    );

    XCTAssertEqual(
        [calendar component:NSCalendarUnitDay fromDate:startDate],
        [calendar component:NSCalendarUnitDay fromDate:[worktime valueForKey:@"endDate"]]
    );
}

- (void) testCanSetNilEndDateAfterDateWasSet {
    id worktime = [self createWorktime];
    id endDate = [timeComputation timeFromDate: [NSDate dateWithTimeIntervalSinceNow:60*60*24*3]];
    [worktime setValue:endDate forKey:@"endDate"];
    [worktime setValue:nil forKey:@"endDate"];
    XCTAssertNil([worktime valueForKey:@"endDate"]);
}

- (void) donttestContinuallyUpdateWorktimeAsLongAsEndDateIsNotSet {
    // too slow, would need to wait one minute or find a way to fake the system time
	id worktime = [self createWorktime];
	id startTime = [timeComputation timeFromDate:[NSDate dateWithTimeIntervalSinceNow:-37]];
	[worktime setValue:startTime forKey:@"startDate"];
	XCTAssertEqualObjects(@"0:00", [worktime hoursAndMinutesFromDuration], @"before sleep");
	sleep(1);
	XCTAssertEqualObjects(@"0:01", [worktime hoursAndMinutesFromDuration], @"after sleep");
}

@end
