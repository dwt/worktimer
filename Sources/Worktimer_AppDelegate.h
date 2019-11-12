//  Created by Martin Häcker on 12.02.06.
//  Copyright M-Soft, IT-Dienste 2006 . All rights reserved.

#import <Cocoa/Cocoa.h>

@interface Worktimer_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    IBOutlet NSTableView *table;
    IBOutlet NSArrayController *worktimeController;
    IBOutlet NSTextField *startTimeField, *endTimeField;
    IBOutlet NSArrayController *worktimesController, *summaryController;
    IBOutlet NSTextField *timeWorking;
    
    IBOutlet NSPanel *summaryWindow;
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
	NSTimer *timer;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction) saveAction:sender;
- (IBAction) pasteTime:sender;
- (IBAction) addWorktimeAndSetFocus:sender;
- (IBAction) showWeeklyReport:sender;

- (void) refreshSorting;
- (void) setupContinousWorktimeDisplay;
- weeklyReport;

@end
