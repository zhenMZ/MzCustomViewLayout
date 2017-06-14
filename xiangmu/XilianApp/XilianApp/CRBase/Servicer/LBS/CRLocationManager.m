//
//  CRLocationManager.m
//  ZGXL
//
//  Created by 任超 on 15/7/12.
//  Copyright (c) 2015年 Roger Abyss. All rights reserved.
//

#import "CRLocationManager.h"
#import "CRLocationRequest.h"

@interface CRLocationManager () <CLLocationManagerDelegate,CRLocationRequestDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL isUpdatingLocation;
@property (nonatomic, assign) BOOL updateFailed;

@property (nonatomic, strong) NSMutableArray *locationRequests;
@end

@implementation CRLocationManager

static CRLocationManager* __manager = nil;

+ (CRLocationManager *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[CRLocationManager alloc] init];
    });
    
    return __manager;
}

- (instancetype)init
{
    NSAssert(__manager == nil, @"Only one instance of CRLocationManager should be created. Use +[CRLocationManager sharedInstance] instead.");
    self = [super init];
    if (self) {
        _locationManager          = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationRequests         = [NSMutableArray array];
    }
    return self;
}

#pragma mark - get/set

+ (CRLocationServiceState)locationServicesState
{
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return CRLocationServicesStateDisabled;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        return CRLocationServicesStateNotDetermined;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return CRLocationServicesStateDenied;
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        return CRLocationServicesStateRestricted;
    }
    
    return CRLocationServicesStateAvailable;
}


- (CRLocationRequestID)requestLocationUserblock:(CRLocationRequestBlock)block
{
    return [self requestLocationWithDesiredAccuracy:CRLocationAccuracyRoom
                                            timeout:0
                                              block:block];
}

- (CRLocationRequestID)requestLocationCityblock:(CRLocationRequestBlock)block
{
    return [self requestLocationWithDesiredAccuracy:CRLocationAccuracyCity
                                            timeout:0
                                              block:block];
}

- (CRLocationRequestID)requestLocationWithDesiredAccuracy:(CRLocationAccuracy)desiredAccuracy
                                                  timeout:(NSTimeInterval)timeout
                                                    block:(CRLocationRequestBlock)block
{
    if (desiredAccuracy == CRLocationAccuracyNone) {
        NSAssert(desiredAccuracy != CRLocationAccuracyNone, @"CRLocationAccuracyNone is not a valid desired accuracy.");
        desiredAccuracy = CRLocationAccuracyCity;
    }
    
    CRLocationRequest *locationRequest = [[CRLocationRequest alloc] init];
    locationRequest.delegate           = self;
    locationRequest.desiredAccuracy    = desiredAccuracy;
    locationRequest.timeout            = timeout;
    locationRequest.block              = block;
    
    BOOL deferTimeout = timeout==0 && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
    if (!deferTimeout) {
        [locationRequest startTimeoutTimerIfNeeded];
    }
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
}

- (CRLocationRequestID)subscribeToLocationUpdatesWithBlock:(CRLocationRequestBlock)block
{
    CRLocationRequest *locationRequest = [[CRLocationRequest alloc] init];
    locationRequest.desiredAccuracy = CRLocationAccuracyNone; // This makes the location request a subscription
    locationRequest.block = block;
    
    [self addLocationRequest:locationRequest];
    
    return locationRequest.requestID;
}

/**
 Immediately forces completion of the location request with the given requestID (if it exists), and executes the original request block with the results.
 This is effectively a manual timeout, and will result in the request completing with status CRLocationStatusTimedOut.
 */
- (void)forceCompleteLocationRequest:(CRLocationRequestID)requestID
{
    CRLocationRequest *locationRequestToComplete = nil;
    for (CRLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            locationRequestToComplete = locationRequest;
            break;
        }
    }
    if (locationRequestToComplete) {
        if (locationRequestToComplete.isSubscription) {
            // Subscription requests can only be canceled
            [self cancelLocationRequest:requestID];
        } else {
            [locationRequestToComplete forceTimeout];
            [self completeLocationRequest:locationRequestToComplete];
        }
    }
}

/**
 Immediately cancels the location request with the given requestID (if it exists), without executing the original request block.
 */
- (void)cancelLocationRequest:(CRLocationRequestID)requestID
{
    CRLocationRequest *locationRequestToCancel = nil;
    for (CRLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.requestID == requestID) {
            locationRequestToCancel = locationRequest;
            break;
        }
    }
    if (locationRequestToCancel) {
        [self.locationRequests removeObject:locationRequestToCancel];
        [locationRequestToCancel cancel];
        
        [self stopUpdatingLocationIfPossible];
    }
}

#pragma mark Internal methods

/**
 Adds the given location request to the array of requests, and starts location updates if needed.
 */
- (void)addLocationRequest:(CRLocationRequest *)locationRequest
{
    CRLocationServiceState locationServicesState = [CRLocationManager locationServicesState];
    if (locationServicesState == CRLocationServicesStateDisabled ||
        locationServicesState == CRLocationServicesStateDenied ||
        locationServicesState == CRLocationServicesStateRestricted) {
        // No need to add this location request, because location services are turned off device-wide, or the user has denied this app permissions to use them
        [self completeLocationRequest:locationRequest];
        return;
    }
    
    [self startUpdatingLocationIfNeeded];
    [self.locationRequests addObject:locationRequest];
}

/**
 Returns the most recent current location, or nil if the current location is unknown, invalid, or stale.
 */
- (CLLocation *)currentLocation
{
    if (_currentLocation) {
        // Location isn't nil, so test to see if it is valid
        if (_currentLocation.coordinate.latitude == 0.0 && _currentLocation.coordinate.longitude == 0.0) {
            // The current location is invalid; discard it and return nil
            _currentLocation = nil;
        }
    }
    
    // Location is either nil or valid at this point, return it
    return _currentLocation;
}

/**
 Inform CLLocationManager to start sending us updates to our location.
 */
- (void)startUpdatingLocationIfNeeded
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    // As of iOS 8, apps must explicitly request location services permissions. CRLocationManager supports both levels, "Always" and "When In Use".
    // CRLocationManager determines which level of permissions to request based on which description key is present in your app's Info.plist
    // If you provide values for both description keys, the more permissive "Always" level is requested.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1 && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
        BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
        if (hasAlwaysKey) {
            [self.locationManager requestAlwaysAuthorization];
        } else if (hasWhenInUseKey) {
            [self.locationManager requestWhenInUseAuthorization];
        } else {
            // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
            NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
        }
    }
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
    
    // We only enable location updates while there are open location requests, so power usage isn't a concern.
    // As a result, we use the Best accuracy on CLLocationManager so that we can quickly get a fix on the location,
    // clear out the pending location requests, and then power down the location services.
    if ([self.locationRequests count] == 0) {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
        
//        if (self.isUpdatingLocation == NO)
//        {
//        }
        self.isUpdatingLocation = YES;
    }
}

/**
 Checks to see if there are any outstanding locationRequests, and if there are none, informs CLLocationManager to stop sending
 location updates. This is done as soon as location updates are no longer needed in order to conserve the device's battery.
 */
- (void)stopUpdatingLocationIfPossible
{
    if ([self.locationRequests count] == 0) {
        [self.locationManager stopUpdatingLocation];
        
//        if (self.isUpdatingLocation) {
//            CRLMLog(@"Location services stopped.");
//        }
        self.isUpdatingLocation = NO;
    }
}

/**
 Iterates over the array of pending location requests to check and see if the most recent current location
 successfully satisfies any of their criteria.
 */
- (void)processLocationRequests
{
    CLLocation *mostRecentLocation = self.currentLocation;
    
    // Keep a separate array of location requests to complete to avoid modifying the locationRequests property while iterating over it
    NSMutableArray *locationRequestsToComplete = [NSMutableArray array];
    
    for (CRLocationRequest *locationRequest in self.locationRequests) {
        if (locationRequest.hasTimedOut) {
            // Request has timed out, complete it
            [locationRequestsToComplete addObject:locationRequest];
            continue;
        }
        
        if (mostRecentLocation != nil) {
            if (locationRequest.isSubscription) {
                // This is a subscription request, which lives indefinitely (unless manually canceled) and receives every location update we get
                [self processSubscriptionRequest:locationRequest];
                continue;
            } else {
                // This is a regular one-time location request
                NSTimeInterval currentLocationTimeSinceUpdate = fabs([mostRecentLocation.timestamp timeIntervalSinceNow]);
                CLLocationAccuracy currentLocationHorizontalAccuracy = mostRecentLocation.horizontalAccuracy;
                NSTimeInterval staleThreshold = [locationRequest updateTimeStaleThreshold];
                CLLocationAccuracy horizontalAccuracyThreshold = [locationRequest horizontalAccuracyThreshold];
                if (currentLocationTimeSinceUpdate <= staleThreshold &&
                    currentLocationHorizontalAccuracy <= horizontalAccuracyThreshold) {
                    // The request's desired accuracy has been reached, complete it
                    [locationRequestsToComplete addObject:locationRequest];
                    continue;
                }
            }
        }
    }
    
    for (CRLocationRequest *locationRequest in locationRequestsToComplete) {
        [self completeLocationRequest:locationRequest];
    }
}

/**
 Immediately completes all pending location requests.
 Used in cases such as when the location services authorization status changes to Denied or Restricted.
 */
- (void)completeAllLocationRequests
{
    // Iterate through a copy of the locationRequests array to avoid modifying the same array we are removing elements from
    NSArray *locationRequests = [self.locationRequests copy];
    for (CRLocationRequest *locationRequest in locationRequests) {
        [self completeLocationRequest:locationRequest];
    }
//    CRLMLog(@"Finished completing all location requests.");
}

/**
 Completes the given location request by removing it from the array of locationRequests and executing its completion block.
 If this was the last pending location request, this method also turns off location updating.
 */
- (void)completeLocationRequest:(CRLocationRequest *)locationRequest
{
    if (locationRequest == nil) {
        return;
    }
    
    [locationRequest complete];
    [self.locationRequests removeObject:locationRequest];
    [self stopUpdatingLocationIfPossible];
    
    CRLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    CRLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];
    
    // CRLocationManager is not thread safe and should only be called from the main thread, so we should already be executing on the main thread now.
    // dispatch_async is used to ensure that the completion block for a request is not executed before the request ID is returned, for example in the
    // case where the user has denied permission to access location services and the request is immediately completed with the appropriate error.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"");
        if (locationRequest.block) {
            locationRequest.block(currentLocation, achievedAccuracy, status);
        }
    });
    
//    CRLMLog(@"Location Request completed with ID: %ld, currentLocation: %@, achievedAccuracy: %lu, status: %lu", (long)locationRequest.requestID, currentLocation, (unsigned long) achievedAccuracy, (unsigned long)status);
}

/**
 Handles calling a subscription location request's block with the current location.
 */
- (void)processSubscriptionRequest:(CRLocationRequest *)locationRequest
{
    NSAssert(locationRequest.isSubscription, @"This method should only be called for subscription location requests.");
    
    CRLocationStatus status = [self statusForLocationRequest:locationRequest];
    CLLocation *currentLocation = self.currentLocation;
    CRLocationAccuracy achievedAccuracy = [self achievedAccuracyForLocation:currentLocation];
    
    // No need for dispatch_async when calling this block, since this method is only called from a CLLocationManager callback
    if (locationRequest.block) {
        locationRequest.block(currentLocation, achievedAccuracy, status);
    }
}

/**
 Returns the location manager status for the given location request.
 */
- (CRLocationStatus)statusForLocationRequest:(CRLocationRequest *)locationRequest
{
    CRLocationServiceState locationServicesState = [CRLocationManager locationServicesState];
    
    if (locationServicesState == CRLocationServicesStateDisabled) {
        return CRLocationStatusServicesDisabled;
    }
    else if (locationServicesState == CRLocationServicesStateNotDetermined) {
        return CRLocationStatusServicesNotDetermined;
    }
    else if (locationServicesState == CRLocationServicesStateDenied) {
        return CRLocationStatusServicesDenied;
    }
    else if (locationServicesState == CRLocationServicesStateRestricted) {
        return CRLocationStatusServicesRestricted;
    }
    else if (self.updateFailed) {
        return CRLocationStatusError;
    }
    else if (locationRequest.hasTimedOut) {
        return CRLocationStatusTimedOut;
    }
    
    return CRLocationStatusSuccess;
}

/**
 Returns the associated CRLocationAccuracy level that has been achieved for a given location,
 based on that location's horizontal accuracy and recency.
 */
- (CRLocationAccuracy)achievedAccuracyForLocation:(CLLocation *)location
{
    if (!location) {
        return CRLocationAccuracyNone;
    }
    
    NSTimeInterval timeSinceUpdate = fabs([location.timestamp timeIntervalSinceNow]);
    CLLocationAccuracy horizontalAccuracy = location.horizontalAccuracy;
    
    if (horizontalAccuracy <= rAccuracyThresholdRoom &&
        timeSinceUpdate <= rAccuracyThresholdRoom) {
        return rAccuracyThresholdRoom;
    }
    else if (horizontalAccuracy <= rAccuracyThresholdHouse &&
             timeSinceUpdate <= rAccuracyThresholdHouse) {
        return rAccuracyThresholdHouse;
    }
    else if (horizontalAccuracy <= rAccuracyThresholdBlock &&
             timeSinceUpdate <= rAccuracyThresholdBlock) {
        return rAccuracyThresholdBlock;
    }
    else if (horizontalAccuracy <= rAccuracyThresholdNeighborhood &&
             timeSinceUpdate <= rAccuracyThresholdNeighborhood) {
        return rAccuracyThresholdNeighborhood;
    }
    else if (horizontalAccuracy <= rAccuracyThresholdCity &&
             timeSinceUpdate <= rAccuracyThresholdCity) {
        return CRLocationAccuracyCity;
    }
    else {
        return CRLocationAccuracyNone;
    }
}

#pragma mark CRLocationRequestDelegate method

- (void)locationRequestDidTimeout:(CRLocationRequest *)locationRequest
{
    // For robustness, only complete the location request if it is still pending (by checking to see that it hasn't been removed from the locationRequests array).
    // Wait to complete it until after exiting the for loop, so we don't modify the array while iterating over it.
    BOOL isRequestStillPending = NO;
    for (CRLocationRequest *pendingLocationRequest in self.locationRequests) {
        if (pendingLocationRequest.requestID == locationRequest.requestID) {
            isRequestStillPending = YES;
            break;
        }
    }
    if (isRequestStillPending) {
        [self completeLocationRequest:locationRequest];
    }
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Received update successfully, so clear any previous errors
    self.updateFailed = NO;
    
    CLLocation *mostRecentLocation = [locations lastObject];
    self.currentLocation = mostRecentLocation;
    
    // The updated location may have just satisfied one of the pending location requests, so process them now to check
    [self processLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    CRLMLog(@"Location update error: %@", [error localizedDescription]);
    self.updateFailed = YES;
    
    [self completeAllLocationRequests];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // Clear out any pending location requests (which will execute the blocks with a status that reflects
        // the unavailability of location services) since we now no longer have location services permissions
        [self completeAllLocationRequests];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
#else
        else if (status == kCLAuthorizationStatusAuthorized) {
#endif /* __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1 */
            // Start the timeout timer for location requests that were waiting for authorization
            for (CRLocationRequest *locationRequest in self.locationRequests) {
                [locationRequest startTimeoutTimerIfNeeded];
            }
        }
    }
    
#pragma mark Deprecated methods
    
    /**
     DEPRECATED, will be removed in a future release. Please use +[CRLocationManager locationServicesState] instead.
     Returns YES if location services are enabled in the system settings, and the app has NOT been denied/restricted access. Returns NO otherwise.
     Note that this method will return YES even if the authorization status has not yet been determined.
     */
    - (BOOL)locationServicesAvailable
    {
        if ([CLLocationManager locationServicesEnabled] == NO) {
            return NO;
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            return NO;
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            return NO;
        }
        
        return YES;
    }


@end
