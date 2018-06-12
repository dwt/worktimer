//  Created by Martin Häcker on 12.02.06.
//  Copyright 2006 M-Soft, IT-Dienste. All rights reserved.

#import <CoreData/CoreData.h>


@interface Worktime :  NSManagedObject  
{
}

- (NSString *)hoursAndMinutesFromDuration;

@end
