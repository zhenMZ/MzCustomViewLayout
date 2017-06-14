#import "CRConvertUtil.h"

@implementation CRConvertUtil

+ (id)object:(id)object to:(Class)pClass
{
    if(!object)
    {
        return nil;
    }
    
    if([object isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    if([object isKindOfClass:pClass])
    {
        return object;
    }
    
    Class CLASS_NUMBER = [NSNumber class];
    Class CLASS_STRING = [NSString class];
    
    if([pClass isSubclassOfClass:CLASS_STRING])  // to string
    {
        if([object isKindOfClass:CLASS_NUMBER])
        {
            return [((NSNumber*)object) stringValue];
        }
    }
    else if([pClass isSubclassOfClass:CLASS_NUMBER]) // to number
    {
        if([object isKindOfClass:CLASS_STRING])
        {
            static NSNumberFormatter* s_formater = nil;
            
            static dispatch_once_t once;
            dispatch_once(&once, ^{
                if(!s_formater)
                {
                    s_formater = [[NSNumberFormatter alloc] init];
                }
                [s_formater setNumberStyle:NSNumberFormatterDecimalStyle];
            });
            
            return [s_formater numberFromString:object];
        }
    }
    
    return nil;
}

+ (NSInteger)objectToInteger:(id)object
{
    NSNumber* number = [self object:object to:[NSNumber class]];
    
    return number ? [number integerValue] : 0;
}

+ (double)objectToDouble:(id)object
{
    NSNumber* number = [self object:object to:[NSNumber class]];
    
    return number ? [number doubleValue] : 0.0;
}

+ (int)objectToInt:(id)object
{
    NSNumber* number = [self object:object to:[NSNumber class]];
    
    return number ? [number intValue] : 0;
}

+ (float)objectToFloat:(id)object
{
    NSNumber* number = [self object:object to:[NSNumber class]];
    
    return number ? [number floatValue] : 0.0f;
}

+ (long)objectToLong:(id)object
{
    NSNumber* number = [self object:object to:[NSNumber class]];
    
    return number ? [number longValue] : 0L;
}

+ (BOOL)objectToBool:(id)object
{
    NSString* svalue = [CRConvertUtil object:object to:[NSString class]];
    
    if(svalue)
    {
        svalue = [svalue lowercaseString];
        if([svalue isEqualToString:@"true"] || [svalue isEqualToString:@"yes"])
        {
            return TRUE;
        }
    }
    
    NSNumber* nvalue = [CRConvertUtil object:object to:[NSNumber class]];
    return nvalue.boolValue;
}

@end
