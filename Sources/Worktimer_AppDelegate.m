//  Created by Martin Häcker on 12.02.06.
//  Copyright M-Soft, IT-Dienste 2006 . All rights reserved.

#import "Worktimer_AppDelegate.h"
#import "Worktime.h"
#import "TimeComputation.h"


@implementation Worktimer_AppDelegate

- (void)awakeFromNib {
    [self refreshSorting];
	[self setupContinousWorktimeDisplay];
}

- (void) refreshSorting;
{
    id sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    id sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[worktimeController setSortDescriptors:sortDescriptors];
}

- (void) setupContinousWorktimeDisplay;
{
	[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeDisplayed:) userInfo:nil repeats:YES];
}

- (void) updateTimeDisplayed: (NSTimer *)unused;
{
	// Also note the binding that also updates this value, so there is no delay when a different value is selected
	id selection = [worktimeController selectedObjects];
	if (1 != [selection count])
		return;
	
	id worktime = [selection objectAtIndex:0];
	[timeWorking setStringValue:[worktime hoursAndMinutesFromDuration]];
}

BOOL isViewSuperviewOf( id view, id viewToTest)
{
    id currentView = viewToTest;
	do {
        if (currentView == view) return YES;
    } while ((currentView = [currentView superview]));
    return NO;
}

- (IBAction)pasteTime:sender;
{
    if (1 != [[worktimesController selectedObjects] count]) return;
    
    id worktime = [[worktimesController selectedObjects] objectAtIndex: 0];
	id currentTime = [[TimeComputation sharedInstance] currentTime];
	
	// I don't get this, why the superfield test?
	if (isViewSuperviewOf(startTimeField, [window firstResponder])) {
        [worktime setValue: currentTime forKey: @"startTime"];
    }
    else if (isViewSuperviewOf(endTimeField, [window firstResponder])) {
        [worktime setValue: currentTime forKey: @"endTime"];
    }
}

- (IBAction) addWorktimeAndSetFocus:sender;
{
    [worktimeController insert: sender];
    [self refreshSorting];
    [startTimeField selectText: sender];
}

BOOL isSameWeek(id firstDate, id secondDate) {
    id gregorianCalendar = [NSCalendar currentCalendar];
    unsigned calendarFlags = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth;
	
    id firstComponents = [gregorianCalendar components:calendarFlags fromDate:firstDate];
    id secondComponents = [gregorianCalendar components:calendarFlags fromDate:secondDate];
    return [firstComponents year] == [secondComponents year]
	&& [firstComponents weekOfMonth] == [secondComponents weekOfMonth];
}

void printReport(id self, id date, NSTimeInterval worktime) {
    id gregorianCalendar = [NSCalendar currentCalendar];
    unsigned calendarFlags = NSCalendarUnitYear | NSCalendarUnitWeekOfMonth;
    id dateComponents = [gregorianCalendar components:calendarFlags fromDate:date];
    
    NSLog(@"year: %ld week: %ld worktime: %@", 
          [dateComponents year], 
          [dateComponents weekOfMonth],
          [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:worktime]);
}

NSDateComponents *dateComponentsFromDate(NSDate *date) {
	id gregorianCalendar = [NSCalendar currentCalendar];
    unsigned calendarFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth;
    return [gregorianCalendar components:calendarFlags fromDate:date];
}	

id year(id date) {
    return [NSNumber numberWithInteger:[dateComponentsFromDate(date) year]];
}

id month(id date) {
	return [NSNumber numberWithInteger:[dateComponentsFromDate(date) month]];
}

id week(id date) {
    return [NSNumber numberWithInteger:[dateComponentsFromDate(date) weekOfMonth]];
}

- weeklyReport {
    id results = [NSMutableArray array];
    id each, enumerator = [[worktimeController arrangedObjects] reverseObjectEnumerator];
    each = [enumerator nextObject];
	int lastMonth = 0;
	NSTimeInterval worktimeInOneMonth = 0;
    while (nil != each) {
        id date = [each valueForKey:@"date"];
        NSTimeInterval worktimeInOneWeek = 0;
		if (lastMonth != [month(date) intValue]) {
			worktimeInOneMonth = 0;
			lastMonth = [month(date) intValue];
		}
        while (isSameWeek(date, [each valueForKey:@"date"])) {
            worktimeInOneWeek += [[each valueForKey:@"endTime"] timeIntervalSinceDate: [each valueForKey:@"startTime"]];
            each = [enumerator nextObject];
        }
		worktimeInOneMonth += worktimeInOneWeek;
        [results addObject: [NSDictionary dictionaryWithObjectsAndKeys:
							 year(date), @"year",
							 week(date), @"week",
							 [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:worktimeInOneWeek], @"worktime", 
							 [[TimeComputation sharedInstance] hoursAndMinutesFromInterval:worktimeInOneMonth], @"worktimeMonth", 
							 nil]];
    }
	id reversedResults = [NSMutableArray array];
	enumerator = [results reverseObjectEnumerator];
	while ((each = [enumerator nextObject]))
		[reversedResults addObject:each];
    return reversedResults;
}

- (IBAction) showWeeklyReport:sender; {
    [summaryController setContent:[self weeklyReport]];
    [summaryWindow makeKeyAndOrderFront:nil];
}


#pragma mark Boilerplate Code

/**
 Returns the support folder for the application, used to store the Core Data
 store file.  This code uses a folder named "Worktimer" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Worktimer"];
}

// using the persistentContainer would be the more modern way to setup a CoreData stack today
// it should require less code all in all, maybe watch a core data session from the wwdc to get up to speed?
//- (NSPersistentContainer *)persistentContainer {
//    if (persistentContainer != nil) {
//        return persistentContainer;
//    }
//
//    persistentContainer = [NSPersistentContainer persistentContainerWithName:@"Worktimer_Datamodel" managedObjectModel:[self managedObjectModel]];
//    [persistentContainer loadPersistentStoresWithCompletionHandler: ^(id store, id error){
//        if (error) {
//            [[NSApplication sharedApplication] presentError:error];
//        }
//
//        NSPersistentStoreDescription *description = [[[NSPersistentStoreDescription alloc] init] autorelease];
////        description.shouldMigrateStoreAutomatically = true;
////        description.shouldInferMappingModelAutomatically = true;
//        [persistentContainer setPersistentStoreDescriptions:@[description]];
//    }];
//    return persistentContainer;
//}
/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle and all of the 
 framework bundles.
 */

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    NSMutableSet *allBundles = [[NSMutableSet alloc] init];
    [allBundles addObject: [NSBundle mainBundle]];
    [allBundles addObjectsFromArray: [NSBundle allFrameworks]];
    
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles: [allBundles allObjects]] retain];
    [allBundles release];
    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The folder for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportFolder = [self applicationSupportFolder];
    NSError *error;
	if ( ! [fileManager createDirectoryAtPath:applicationSupportFolder withIntermediateDirectories:YES attributes:nil error:&error])
		[[NSApplication sharedApplication] presentError:error];
	
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"Worktimer.xml"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    NSPersistentStoreDescription *description = [NSPersistentStoreDescription persistentStoreDescriptionWithURL:url];
    description.shouldMigrateStoreAutomatically = true;
    description.shouldInferMappingModelAutomatically = true;
    description.type = NSXMLStoreType;
    [persistentStoreCoordinator addPersistentStoreWithDescription:description completionHandler: ^(id description, id error) {
        if (error) {
            [[NSApplication sharedApplication] presentError:error];
        }
    }];

//    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error])
//        [[NSApplication sharedApplication] presentError:error];
	
    return persistentStoreCoordinator;
}


/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext)
        return managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if ( ! coordinator)
		return nil;
	
	managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
    
    return managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */ 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window { 
    return [[self managedObjectContext] undoManager];
}

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */
- (IBAction) saveAction:(id)sender
{
	NSError *error = nil;
    if ( ! [[self managedObjectContext] save:&error])
        [[NSApplication sharedApplication] presentError:error];
}

/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    if ( ! managedObjectContext)
		return NSTerminateNow; // not even loaded a document
	
	if ( ! [managedObjectContext commitEditing])
		return NSTerminateCancel; // non valid input in NSTextField probably - retry later
	
	if ( ! [managedObjectContext hasChanges])
		return NSTerminateNow; // no changes
	
	NSError *error;
	if ([managedObjectContext save:&error])
		return NSTerminateNow; // saved successfully
	
	// we could not save
	
	// This error handling simply presents error information in a panel with an 
	// "Ok" button, which does not include any attempt at error recovery (meaning, 
	// attempting to fix the error.)  As a result, this implementation will 
	// present the information to the user and then follow up with a panel asking 
	// if the user wishes to "Quit Anyway", without saving the changes.
	
	// Typically, this process should be altered to include application-specific 
	// recovery steps.
	
	if ([[NSApplication sharedApplication] presentError:error])
		return NSTerminateNow; // error handling succeeded
	
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    alert.alertStyle = NSAlertStyleCritical;
    alert.messageText = NSLocalizedString(@"Unable to save", nil);
    alert.informativeText = NSLocalizedString(@"Unabel to save changes while quitting. Continue to run?", nil);
    [alert addButtonWithTitle:NSLocalizedString(@"Continue to run", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Quit", nil)];
    
	if (NSAlertFirstButtonReturn == [alert runModal])
		return NSTerminateCancel; // continue to run
	else
		return NSTerminateNow; // quit
}


/**
 Implementation of dealloc, to release the retained variables.
 */
- (void) dealloc
{
	// FIXME: this will never be reached as long as the timer is active.
	// To invalidate it, I'd need to hold on to a strong reference, which would create a cycle.
	// I could try __weak though.
    [managedObjectContext release];
    managedObjectContext = nil;
    
    [persistentStoreCoordinator release];
    persistentStoreCoordinator = nil;
    
    [managedObjectModel release];
    managedObjectModel = nil;
	
	[super dealloc];
}


@end
