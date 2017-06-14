//
//  CRMutableDictionaryWrapper.m
//  Pods
//
//  Created by 任超 on 15/7/23.
//
//

#import "CRMutableDictionaryWrapper.h"

#import "CRConvertUtil.h"

@interface StackItem : NSObject
@property (copy, nonatomic) NSString* key;
@property (retain, nonatomic) NSDictionary* object;
@end

@implementation StackItem
@synthesize object = _object, key = _key;

+ (instancetype) itemFrom:(NSDictionary*)object key:(NSString*)key
{
    StackItem* ret = [[StackItem alloc] init];
    ret.object = object;
    ret.key    = key;
    
    return ret;
}
@end

@implementation CRMutableDictionaryWrapper

@synthesize dictionary = _dictionary;

- (void)reset:(NSArray *)stack at:(int)index key:(NSString *)key value:(id)value
{
    if(index == 0) // setup on _dictionary
    {
        _dictionary = value;
        
        return ;
    }
    
    id        parent    = [stack[index] object];
    NSString* parentKey = [stack[index] key];
    @try
    {
        if([parent isKindOfClass:[CRMutableDictionaryWrapper class]])
        {
            [(CRMutableDictionaryWrapper *)parent set:key value:value];
        }
        else if(value)
        {
            [parent setValue:value forKey:key];
        }
        else
        {
            [parent removeObjectForKey:key];
        }
    }
    @catch (NSException *exception)
    {
        if ([parent isKindOfClass:[CRDictionaryWrapper class]])
        {
            parent = [[NSMutableDictionary alloc] initWithDictionary:[parent dictionary]];
        }
        else
        {
            parent = [[NSMutableDictionary alloc] initWithDictionary:parent];
        }
        
        
        if(value)
        {
            [parent setValue:value forKey:key];
        }
        else
        {
            [parent removeObjectForKey:key];
        }
        
        [stack[index] setObject:parent];
        
        [self reset:stack at:index-1 key:parentKey value:parent];
    }
}

- (void)set:(NSString *)name value:(id)value
{
    if(!_dictionary)
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSArray* components = [name componentsSeparatedByString:@"."];
    
    NSMutableArray* stack = [[NSMutableArray alloc] init];
    [stack addObject:[[StackItem alloc] init]];  // Place holder, _dictionary parent
    [stack addObject:[StackItem itemFrom:self.dictionary key:@""]]; // _dictionary
    
    NSMutableDictionary* object = (NSMutableDictionary*)_dictionary;
    
    int i = 0;
    int i_sz = ((int)components.count) - 1;
    for(i=0; i<i_sz; ++i)
    {
        NSString* key = components[i];
        
        if([object isKindOfClass:[CRDictionaryWrapper class]])
        {
            object = [(CRDictionaryWrapper *)object get:key];
        }
        else
        {
            object = [object objectForKey:key];
        }
        
        if(![object isKindOfClass:[CRDictionaryWrapper class]])
        {
            object = [CRConvertUtil object:object to:[NSDictionary class]];
        }
        
        if(!object)
        {
            object = [[NSMutableDictionary alloc] init];
            
            [self reset:stack at:(int)stack.count-1 key:key value:object];
        }
        
        [stack addObject:[StackItem itemFrom:object key:key]];
    }
    
    [self reset:stack at:(int)stack.count-1 key:components.lastObject value:value];
}

- (void) set:(NSString*)name bool:(BOOL)value
{
    [self set:name value:[NSNumber numberWithBool:value]];
}

- (void) set:(NSString*)name int:(int)value
{
    [self set:name value:[NSNumber numberWithInt:value]];
}

- (void) set:(NSString*)name string:(NSString*)value
{
    [self set:name value:value];
}

- (void) set:(NSString*)name float:(float)value
{
    [self set:name value:[NSNumber numberWithFloat:value]];
}

- (void) set:(NSString*)name double:(double)value
{
    [self set:name value:[NSNumber numberWithDouble:value]];
}

- (void) set:(NSString*)name long:(long)value
{
    [self set:name value:[NSNumber numberWithLong:value]];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"CRMutableDictionaryWrapper\n%@", [_dictionary description]];
}

@end

@implementation NSDictionary (MutableWrapper)

- (CRMutableDictionaryWrapper *)wrapper
{
    return [CRMutableDictionaryWrapper wrapperFromDictionary:self];
}

@end
