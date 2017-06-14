/**
 *  ==============CRLocationRequest============
 *   CRLocationRequest
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */

#import "CRLocationDefiner.h"
#import "CRLocationManager.h"

@class CRLocationRequest;
@protocol CRLocationRequestDelegate

- (void)locationRequestDidTimeout:(CRLocationRequest *)locationRequest;

@end


@interface CRLocationRequest : NSObject

@property (nonatomic, weak) id<CRLocationRequestDelegate> delegate;
@property (nonatomic, readonly) CRLocationRequestID requestID;
@property (nonatomic, readonly) BOOL isSubscription;

@property (nonatomic, assign) CRLocationAccuracy desiredAccuracy;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, readonly) NSTimeInterval timeAlive;
@property (nonatomic, readonly) BOOL hasTimedOut;
@property (nonatomic, copy) CRLocationRequestBlock block;

- (void)complete;
- (void)forceTimeout;
- (void)cancel;

- (void)startTimeoutTimerIfNeeded;

- (NSTimeInterval)updateTimeStaleThreshold;

- (CLLocationAccuracy)horizontalAccuracyThreshold;

@end
