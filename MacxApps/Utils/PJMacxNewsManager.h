//
//  PJMacxNewsManager.h
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface PJMacxNewsManager : NSObject {
    AFURLSessionManager *_manager;
}

+ (instancetype)sharedManager;

@end
