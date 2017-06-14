/**
 *  ==============CRLocationDefiner============
 *   CRLocationDefiner
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//************************** CRLocationManager ********************************

// 定位精度
static const CLLocationAccuracy rAccuracyThresholdCity         = 5000.0;
static const CLLocationAccuracy rAccuracyThresholdNeighborhood = 1000.0;
static const CLLocationAccuracy rAccuracyThresholdBlock        = 100.0;
static const CLLocationAccuracy rAccuracyThresholdHouse        = 15.0;
static const CLLocationAccuracy rAccuracyThresholdRoom         = 5.0;

// 间隔时间
static const NSTimeInterval rUpdateTimeStaleThresholdCity          = 600.0;
static const NSTimeInterval rUpdateTimeStaleThresholdNeighborhood  = 300.0;
static const NSTimeInterval rUpdateTimeStaleThresholdBlock         = 60.0;
static const NSTimeInterval rUpdateTimeStaleThresholdHouse         = 15.0;
static const NSTimeInterval rUpdateTimeStaleThresholdRoom          = 5.0;

typedef NS_ENUM(NSUInteger, CRLocationServiceState)
{
    CRLocationServicesStateAvailable,        // 可用
    
    CRLocationServicesStateNotDetermined,    // 没有授权
    CRLocationServicesStateDenied,           // 用户禁止
    CRLocationServicesStateRestricted,       // 没有权限
    CRLocationServicesStateDisabled          // 禁止
};

typedef NS_ENUM(NSUInteger, CRLocationAccuracy)
{
    // 持续的更新
    CRLocationAccuracyNone = 0,
    
    CRLocationAccuracyCity,
    CRLocationAccuracyNeighborhood,
    CRLocationAccuracyBlock,
    CRLocationAccuracyHouse,
    CRLocationAccuracyRoom,
};

typedef NS_ENUM(NSInteger, CRLocationStatus) {
    CRLocationStatusSuccess = 0,
    
    CRLocationStatusTimedOut,
    
    CRLocationStatusServicesNotDetermined,
    CRLocationStatusServicesDenied,
    CRLocationStatusServicesRestricted,
    CRLocationStatusServicesDisabled,
    
    CRLocationStatusError,
};

//************************** CRLocationManager ********************************

