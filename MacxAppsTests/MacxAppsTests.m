//
//  MacxAppsTests.m
//  MacxAppsTests
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+PJAdditions.h"
#import "PJSoftwareManager.h"

@interface MacxAppsTests : XCTestCase

@end

@implementation MacxAppsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString *s = @"<span title=\"14-8-25 19:00:56\">3&nbsp;\u5c0f\u65f6\u524d</span>";
    NSString *found = [s substringWithBound:@"\"" withBound:@"\"" options:0];
    XCTAssertTrue([@"14-8-25 19:00:56" isEqualToString:found]);
}

- (void)testQueryAllSoftwares
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[PJSoftwareManager sharedManager] queryAllSoftwares:^(id responseObject) {
        NSLog(@"Result: %@", [responseObject className]);
    }];
}

@end
