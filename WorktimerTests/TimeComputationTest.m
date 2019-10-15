//
//  Created by Martin Häcker on 28.04.10.
//  Copyright 2010 DWTs Heavy Industries. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TimeComputation.h"

@interface TimeComputationTest : XCTestCase
@end

@implementation TimeComputationTest

- (void) testSmoke {
	XCTAssertNotNil([[TimeComputation alloc] init]);
}

#define seconds 1
#define minutes 60
#define hours (60 * minutes)

- (void) testCanFormatNoDuration {
	XCTAssertEqualObjects(@"0:00", stringFromTimeInterval(0));
}

- (void) testCanFormatMinutes {
	XCTAssertEqualObjects(@"0:00", stringFromTimeInterval(59));
	XCTAssertEqualObjects(@"0:01", stringFromTimeInterval(60));
	XCTAssertEqualObjects(@"0:59", stringFromTimeInterval(1*hours - 1));
}

- (void) testCanFormatHours {
	XCTAssertEqualObjects(@"1:00", stringFromTimeInterval(1*hours));
	XCTAssertEqualObjects(@"1:59", stringFromTimeInterval(2*hours - 1*seconds));
	XCTAssertEqualObjects(@"25:00", stringFromTimeInterval(25*hours));
}

- (void) testNegativeIntervalsAreStillJustFormatedAsIntervals {
	XCTAssertEqualObjects(@"0:59", stringFromTimeInterval(-1*hours + 1*seconds));
	XCTAssertEqualObjects(@"1:01", stringFromTimeInterval(-1*hours - 1*minutes));
}


@end
