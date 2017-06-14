/**
 *  ===========CRBackgroundTaskManager=========
 *   CRBackgroundTaskManager
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 *  Copyright@voyage11 https://github.com/voyage11/Location
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CRBackgroundTaskManager : NSObject

+ (instancetype)sharedCRBackgroundTaskManager;

- (UIBackgroundTaskIdentifier)beginNewBackgroundTask;
- (void)endAllBackgroundTasks;

@end
