//
//  PJAppsManager.m
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJAppsManager.h"

@implementation PJAppsManager


+ (instancetype)sharedManager {
    static PJAppsManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PJAppsManager alloc] init];
    });
    
    return _instance;
}

- (NSArray *)findApps {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSSystemDomainMask, YES);
    if (!paths || [paths count] == 0) {
        return @[];
    }
    
    NSString *sysApplicationsPath = paths[0];
    NSURL *fileURL = [NSURL fileURLWithPath:sysApplicationsPath];
    NSArray *attrs = @[NSURLNameKey, NSURLFileSizeKey, NSURLAttributeModificationDateKey];
    NSArray *pkgs = [fileMgr contentsOfDirectoryAtURL:fileURL includingPropertiesForKeys:attrs options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    NSMutableArray *apps = [NSMutableArray array];
    for (NSURL *pkgURL in pkgs) {
        NSDictionary *dict = [pkgURL resourceValuesForKeys:attrs error:nil];
        NSString *appName = nil;
        NSURL *plistURL = [pkgURL URLByAppendingPathComponent:@"Contents/Info.plist"];
        NSDictionary *pkgBundleDict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
        if (pkgBundleDict) {
            appName = pkgBundleDict[@"CFBundleName"];
            if (!appName) {
                appName = pkgBundleDict[@"CFBundleExecutable"];
            }
        }
        if (!appName) {
            appName = dict[NSURLNameKey];
        }
        
        NSNumber *appSize = dict[NSURLFileSizeKey];
        if (!appSize) {
            appSize = @(0);
        }
        NSDate *appInstallDate = dict[NSURLAttributeModificationDateKey];
        if (!appInstallDate) {
            appInstallDate = [NSDate date];
        }
        NSDictionary *app = @{@"name": appName, @"size": appSize, @"installDate": appInstallDate};
        [apps addObject:app];
    }
    
    return apps;
}

@end
