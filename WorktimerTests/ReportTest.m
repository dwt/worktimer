//  Created by Martin Häcker on 12.11.19.

#import <XCTest/XCTest.h>

@interface ReportTest : XCTestCase
@end

@implementation ReportTest

#pragma mark Setup

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- managedObjectContext {
    
    return nil;
}

#pragma mark Tests

- (void)testEmptyReport {
    id context = [self managedObjectContext];
    XCTAssert(1 == 1, @"fnord");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
