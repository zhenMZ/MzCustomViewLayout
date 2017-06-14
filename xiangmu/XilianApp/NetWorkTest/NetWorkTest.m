//
//  NetWorkTest.m
//  NetWorkTest
//
//  Created by Abyss on 2017/3/2.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DefaultRequest.h"

@interface NetWorkTest : XCTestCase

@end

@implementation NetWorkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    [self simpleRequest];
}

- (void)simpleRequest
{
    DefaultRequest* request = [[DefaultRequest alloc] init];
    
    request.url = @"http://test.zgxl168.com/apishop/q_g_category";
    request.params = @{};
    
    [request startCallSuccess:^(CRRequest* request, BOOL isCache)
    {
    }
                      failure:^(CRRequest* request){
        
    }];
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
