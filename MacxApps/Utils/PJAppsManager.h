//
//  PJAppsManager.h
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJAppsManager : NSObject

+ (instancetype)sharedManager;

- (NSArray*)findApps;

@end
