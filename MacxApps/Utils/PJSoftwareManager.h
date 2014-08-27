//
//  PJSoftwareManager.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

@interface PJSoftwareManager : NSObject {
    AFURLSessionManager *_manager;
}

+ (instancetype)sharedManager;

- (void)querySoftwareListAll:(void (^)(id obj))responseWith;
- (void)querySoftwareList:(NSInteger)category orderBy:(NSString*)order responseWith:(void (^)(id obj))responseWith;
- (void)likeSoftware:(NSInteger)softId responseWith:(void (^)(id obj))responseWith;
- (void)queryMacxNews:(void (^)(id responseObject))responseWith;

- (void)fetchImage:(NSString*)url;
- (void)downloadFile:(NSString *)url toDirectory:(NSURL *)directoryURL;

- (void)checkNetwork;


@end
