//
//  MZLocal.m
//  XilianApp
//
//  Created by zhen mz on 2017/4/13.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//



#import "MZLocalCity.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MZLocalCity ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) localCityCallBack localCallBack;
@property (nonatomic, copy) failure failure;
@property (nonatomic, copy) localAddressCallBack localAddressCallBack;

@end

@implementation MZLocalCity
static MZLocalCity *instance;

+ (MZLocalCity *)Shared {
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[MZLocalCity alloc] init];
        });
    }
    return instance;
}

+ (void)startLocalAddressSuccess:(localAddressCallBack)localAddressCallBack failure:(failure)failure {
    
    MZLocalCity *local = [MZLocalCity Shared];
    [local startLocation];
    local.localAddressCallBack = localAddressCallBack;
    local.failure = failure;
    
}

+ (void)startLocalCitySuccess:(localCityCallBack)localCallBack failure:(failure)failure {
    
    MZLocalCity *local = [MZLocalCity Shared];
    [local startLocation];
    local.localCallBack = localCallBack;
    local.failure = failure;
}


- (void)startLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    self.locationManager.distanceFilter = distance;
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"-----%@--定位服务不可用", [self class]);
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0) { /// 8.0以前系统不需要授权
        
        [self.locationManager startUpdatingLocation];
        return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) { /// 未经授权状态
        
        [self.locationManager requestWhenInUseAuthorization]; /// 设置授权状态
        [self.locationManager startUpdatingLocation];
        
        return;
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways||[CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
        [self.locationManager startUpdatingLocation];
        return;
    }
}

#pragma mark -- 反地理编码设置--
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];  /// 结束定位
    
    /**********      开始翻遍码        *********/
    CLGeocoder *Geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [locations lastObject];
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [Geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (error && self.failure) {
            self.failure(error);
            return ;
        }
        
        CLPlacemark *placemark = [placemarks firstObject];
        
        if (placemark.addressDictionary && self.localAddressCallBack) {
            self.localAddressCallBack(placemark.addressDictionary);
            return;
        }
        
        if (placemark.addressDictionary[@"City"] && self.localCallBack) {
            self.localCallBack(placemark.addressDictionary[@"City"]);
            return;
        }
    }];
                        
  
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.failure) {
        self.failure(error);
    }
}
@end
