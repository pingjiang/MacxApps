//
//  PJMacxClient.h
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"

extern NSString *const kWillLoadMacxSoftwares;
extern NSString *const kShouldQueryMacxSoftwares;
extern NSString *const kShouldUpdateMacxSoftwares;
extern NSString *const kShouldParseMacxSoftwares;
extern NSString *const kDidQueryMacxSoftwares;
extern NSString *const kDidUpdateMacxSoftwares;
extern NSString *const kDidParseMacxSoftwares;

@interface PJMacxClient : AFHTTPRequestOperationManager

+ (void)initializeNetwork;
+ (instancetype)sharedClient;


- (void)querySoftwareListAll:(void (^)(id obj))responseWith;
- (void)querySoftwareList:(NSInteger)category orderBy:(NSString*)order responseWith:(void (^)(id obj))responseWith;
- (void)likeSoftware:(NSInteger)softId responseWith:(void (^)(id obj))responseWith;
- (void)queryMacxNews:(void (^)(id responseObject))responseWith;

- (void)totalNumbers:(void (^)(id responseObject))responseWith;
- (void)queryAllSoftwares:(void (^)(id responseObject))responseWith;
- (void)ajaxSearch:(NSString*)keyword responseWith:(void (^)(id obj))responseWith;

+ (void)downloadFile:(NSString *)url toDirectory:(NSURL *)directoryURL;

+ (void)checkNetwork;

@end
