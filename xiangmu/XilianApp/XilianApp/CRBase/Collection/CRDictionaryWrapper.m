#import "CRDictionaryWrapper.h"

#import "CRConvertUtil.h"

@implementation CRDictionaryWrapper

- (instancetype)initWith:(NSDictionary *)dictionary
{
    if(!(self = [super init]))
    {
        return nil;
    }
    
    self.dictionary = dictionary;
    
    return self;
}

+ (instancetype)wrapperFromDictionary:(NSDictionary *)dictionary
{
    if(!dictionary)
    {
        dictionary = @{};
    }
    
    return [[self alloc] initWith:dictionary];
}

#pragma mark - Getter

- (id)get:(NSString *)name
{
    if(!self.dictionary)
    {
        return nil;
    }
    
    NSArray* components = [name componentsSeparatedByString:@"."];
    
    NSDictionary* object = self.dictionary;
    id value = nil;
    
    for(NSString* key in components)
    {
        if([object isKindOfClass:[CRDictionaryWrapper class]])
        {
            value = [(CRDictionaryWrapper*)object get:key];
        }
        else if([object isKindOfClass:[NSDictionary class]])
        {
            value  = [object objectForKey:key];
        }
        else
        {
            value = nil;
        }
        
        object = value;
    }
    
    return value;
}

- (NSString *)getString:(NSString *)name
{
    return [CRConvertUtil object:[self get:name] to:[NSString class]]?[CRConvertUtil object:[self get:name] to:[NSString class]]:@"";
}

- (CRDictionaryWrapper *)getDictionaryWrapper:(NSString *)name
{
    id ret = [self get:name];
    
    if([ret isKindOfClass:[CRDictionaryWrapper class]])
    {
        
    }
    else
    {
        ret = [CRDictionaryWrapper wrapperFromDictionary:[CRConvertUtil object:ret to:[NSDictionary class]]];
    }
    
    return ret?ret:@{}.wrapper;
}

- (NSDictionary *)getDictionary:(NSString *)name
{
    id ret = [self get:name];
    
    if([ret isKindOfClass:[CRDictionaryWrapper class]])
    {
        ret = ((CRDictionaryWrapper*)ret).dictionary;
    }
    else
    {
        ret = [CRConvertUtil object:ret to:[NSDictionary class]];
    }
    
    return ret?ret:@{};
}

- (NSArray *)getArray:(NSString *)name
{
    return [CRConvertUtil object:[self get:name] to:[NSArray class]]?[CRConvertUtil object:[self get:name] to:[NSArray class]]:@[];
}

- (NSInteger)getInteger:(NSString *)name
{
    return [CRConvertUtil objectToInteger:[self get:name]];
}

- (double) getDouble:(NSString*)name
{
    return [CRConvertUtil objectToDouble:[self get:name]];
}

- (float) getFloat:(NSString*)name
{
    return [CRConvertUtil objectToFloat:[self get:name]];
}

- (int) getInt:(NSString*)name
{
    return [CRConvertUtil objectToInt:[self get:name]]?[CRConvertUtil objectToInt:[self get:name]]:0;
}

- (long) getLong:(NSString*)name
{
    return [CRConvertUtil objectToLong:[self get:name]];
}

- (BOOL) getBool:(NSString*)name
{
    return [CRConvertUtil objectToBool:[self get:name]];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"CRDictionaryWrapper\n%@", [self.dictionary description]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self dictionary] forKey:@"dictionary"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil)
    {
        self.dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
    }
    
    return self;
}

@end

@implementation NSDictionary (Wrapper)

- (CRDictionaryWrapper*) wrapper
{
    return [CRDictionaryWrapper wrapperFromDictionary:self];
}

@end
