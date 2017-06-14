//
//  CRPersister.m
//  Pods
//
//  Created by 任超 on 15/7/31.
//
//

#import "CRPersistSettingWrpper.h"

@class CRPersister;
@interface CRPersistSettingWrpper()
@property (nonatomic, assign) BOOL dirty;
@property (nonatomic, copy) NSString* persistName;
@end

@implementation CRPersistSettingWrpper

- (void)remove
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_persistName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.dirty       = NO;
    self.dictionary  = nil;
    self.persistName = nil;
}

- (instancetype)initWithName:(NSString *)name
{
    if(!(self = [super init]))
    {
        return nil;
    }
    
    _persistName = name;
    
    NSDictionary* dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:_persistName];
    
    if(dictionary)
    {
        [self setDictionary:dictionary];
    }
    
    return self;
}

- (void)set:(NSString*)name value:(id)value
{
    if([value isKindOfClass:[CRDictionaryWrapper class]]) // Persist Wrapper can't set DictionaryWrapper
    {
        value = [value dictionary];
    }
    
    _dirty = TRUE;
    
    [super set:name value:value];
    
    if(self.dirty)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:_persistName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.dirty = FALSE;
    }
}

#pragma mark - date vakid

- (void)save:(CRPersister *)persister name:(NSString *)name
{
    [self set:name value:persister.dictionary];
}

- (NSArray *)getArray_t:(NSString *)name
{
    CRPersister* persister = [self get:name];
    
    return persister.isValidate?[persister getArray:persister.key]:@[];
}

- (NSInteger)getInteger_t:(NSString *)name
{
    CRPersister* persister = [self get:name];
    
    return persister.isValidate?[persister getInteger:persister.key]:0;
}

- (NSString *)getString_t:(NSString *)name
{
    CRPersister* persister = [self get:name];
    
    return persister.isValidate?[persister getString:persister.key]:@"";
}

- (NSDictionary *)getDictionary_t:(NSString *)name
{
    CRPersister* persister = [self get:name];
    
    return persister.isValidate?[persister getDictionary:persister.key]:@{};
}

- (CRDictionaryWrapper *)getDictionaryWrapper_t:(NSString *)name
{
    CRPersister* persister = [self get:name];
    
    return persister.isValidate?[persister getDictionaryWrapper:persister.key]:@{}.wrapper;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"PersistSettingWrpper\n%@", [self.dictionary description]];
}

+ (instancetype) wrapperFromName:(NSString*)name
{
    return [[CRPersistSettingWrpper alloc] initWithName:name];
}

@end


@implementation CRPersister

- (BOOL)isValidate
{
    return self.date.isValidate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key = @"value";
    }
    return self;
}

+ (CRPersister *)persisterForm:(id)objct
{
    CRPersister* persister = [[CRPersister alloc] init];
    
    CRTimeWrapper* date = [CRTimeWrapper wrapperFromDate:[NSDate date]];
    
    persister.dictionary = @{@"value":objct,
                             @"date":@(date.timeInterval),};
    
    return persister;
}

- (id)object
{
    return [self get:self.key];
}

- (CRTimeWrapper *)date
{
    return [CRTimeWrapper wrapperFromTimeInterval:[self getInteger:@"date"]];
}

- (NSTimeInterval)timeout
{
    return self.date.timeout;
}

- (void)setTimeout:(NSTimeInterval)timeout
{
    self.date.timeout = timeout;
}

@end