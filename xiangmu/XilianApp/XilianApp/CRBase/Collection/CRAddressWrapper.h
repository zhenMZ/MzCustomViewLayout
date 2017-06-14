/**
 *  ==============CRAddressWrapper=============
 *  CRAddressWrapper
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CRAddressWrapper;
typedef void(^AddressChangeBlock)(CRAddressWrapper *place);

@interface CRAddressWrapper : NSObject <NSCoding>

/** 坐标等信息 */
@property (nonatomic, strong) CLLocation* map;
/** 用户附加的地址详情 或者地址概要 */
@property (nonatomic, copy) NSString* address;


@property (nonatomic, copy) NSString* country;
@property (nonatomic, copy) NSString* province;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* district;


/**
 *  异步地址
 *  当仅使用坐标时,会用GEO请求地址,这时属性不会立刻得到。
 */
@property (nonatomic, copy) AddressChangeBlock reserveAddress;

+ (CRAddressWrapper *)wrapperFromAdress:(NSString *)address;

+ (CRAddressWrapper *)wrapperFrom:(CLLocation *)map;

@end
