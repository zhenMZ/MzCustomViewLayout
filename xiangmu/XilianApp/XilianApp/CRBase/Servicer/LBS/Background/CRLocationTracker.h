/**
 *  ============CRLocationShareModel===========
 *   CRLocationShareModel
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 *  Copyright@voyage11 https://github.com/voyage11/Location
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CRBackgroundTaskManager.h"

@class CRLocationShareModel;
@interface CRLocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) CRLocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;


@end

@interface CRLocationShareModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer *delay10Seconds;
@property (nonatomic) CRBackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;

+(id)sharedModel;

@end
