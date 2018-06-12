//
//  Created by Martin Häcker on 28.04.10.
//  Copyright 2010 DWTs Heavy Industries. All rights reserved.
//

#import "TimeComputationTest.h"
#import "TimeComputation.h"

@implementation TimeComputationTest

- (void) testSmoke {
	STAssertNotNil([[TimeComputation alloc] init], nil);
}

#define seconds 1
#define minutes 60
#define hours (60 * minutes)

- (void) testCanFormatNoDuration {
	STAssertEqualObjects(@"0:00", stringFromTimeInterval(0), nil);
}

- (void) testCanFormatMinutes {
	STAssertEqualObjects(@"0:00", stringFromTimeInterval(59), nil);
	STAssertEqualObjects(@"0:01", stringFromTimeInterval(60), nil);
	STAssertEqualObjects(@"0:59", stringFromTimeInterval(1*hours - 1), nil);
}

- (void) testCanFormatHours {
	STAssertEqualObjects(@"1:00", stringFromTimeInterval(1*hours), nil);
	STAssertEqualObjects(@"1:59", stringFromTimeInterval(2*hours - 1*seconds), nil);
	STAssertEqualObjects(@"25:00", stringFromTimeInterval(25*hours), nil);
}

- (void) testNegativeIntervalsAreStillJustFormatedAsIntervals {
	STAssertEqualObjects(@"0:59", stringFromTimeInterval(-1*hours + 1*seconds), nil);
	STAssertEqualObjects(@"1:01", stringFromTimeInterval(-1*hours - 1*minutes), nil);
}


@end
