//
//  PJMacxNewsManager.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJMacxNewsManager.h"

@implementation PJMacxNewsManager

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static PJMacxNewsManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PJMacxNewsManager alloc] init];
    });
    
    return _instance;
}



@end
