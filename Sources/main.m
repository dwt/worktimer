//
//  main.m
//  Worktimer
//
//  Created by Martin HŠcker on 12.02.06.
//  Copyright M-Soft, IT-Dienste 2006. All rights reserved.
//

#import <Cocoa/Cocoa.h>

BOOL isRunningUnitTests() {
    return nil != NSClassFromString(@"XCTestCase");
}

int runApplicationWithoutLoadingGUI() {
    [NSApplication sharedApplication];
    [NSApp run];
    return 0;
}

int main(int argc, char *argv[])
{
    if (isRunningUnitTests())
        return runApplicationWithoutLoadingGUI();
    
    return NSApplicationMain(argc,  (const char **) argv);
}
