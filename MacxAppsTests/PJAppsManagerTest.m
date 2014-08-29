//
//  PJAppsManagerTest.m
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PJAppsManager.h"

@interface PJAppsManagerTest : XCTestCase

@end

@implementation PJAppsManagerTest

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
    NSArray *paths = [[PJAppsManager sharedManager] findApps];
    for (NSString *path in paths) {
        NSLog(@"Found path: %@", path);
    }
}

@end
