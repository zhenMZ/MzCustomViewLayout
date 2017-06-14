/**
 *  =============CRConvertUtil==============
 *   Help Convert Data
 *  ===========================================
 *
 *  Copyright@2015 RogerAbyss
 */

#import <Foundation/Foundation.h>

@interface CRConvertUtil : NSObject

+ (id)object:(id)object to:(Class)pClass;

+ (NSInteger)objectToInteger:(id)object;

+ (int)objectToInt:(id)object;
+ (BOOL)objectToBool:(id)object;
+ (long)objectToLong:(id)object;
+ (float)objectToFloat:(id)object;
+ (double)objectToDouble:(id)object;

@end
