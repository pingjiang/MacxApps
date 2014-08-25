//
//  PJSoftwareManager.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareManager.h"

NSString *const kSoftwareListProviders = @"SoftwareListProviders";

@interface PJSoftwareManager ()

- (id)defaultSoftwareListProvider;

- (void)callApi:(NSString*)name updateParameter:(void (^)(NSMutableDictionary*))updateParameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation PJSoftwareManager

- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static PJSoftwareManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[PJSoftwareManager alloc] init];
    });
    
    return _instance;
}


- (id)defaultSoftwareListProvider {
    NSArray *providers = [[NSUserDefaults standardUserDefaults] arrayForKey:kSoftwareListProviders];
    NSDictionary *provider = [providers firstObject];
    return provider;
}


- (void)callApi:(NSString *)name updateParameter:(void (^)(NSMutableDictionary*))updateParameter success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *provider = [self defaultSoftwareListProvider];
    NSString *url = provider[@"url"];
    NSArray *apis = provider[@"apis"];
    
    NSUInteger found = [apis indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"name"] isEqualToString:name]) {
            return YES;
        }
        
        return NO;
    }];
    
    if (found == NSNotFound) {
        NSLog(@"Api of name %@ not found", name);
        return;
    }
    NSDictionary *api = apis[found];
    NSString *path = api[@"path"];
    NSString *requestURL = path;
    if (path && [path hasPrefix:@"/"]) {
        requestURL = [NSString stringWithFormat:@"%@%@", url, path];
    }
    
    NSMutableDictionary *parameters = [api[@"parameters"] mutableCopy];
    if (updateParameter) {
        updateParameter(parameters);
    }
    
    NSString *contentType = api[@"contentType"];
    NSLog(@"HTTP Request %@ %@, Content-Type: %@", requestURL, parameters, contentType);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (contentType) {
        AFHTTPRequestSerializer * requestSerializer = [AFHTTPRequestSerializer serializer];
        AFHTTPResponseSerializer * responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
        // NSString *ua = @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25";
        // [requestSerializer setValue:ua forHTTPHeaderField:@"User-Agent"];
        [requestSerializer setValue:contentType forHTTPHeaderField:@"Content-type"];
        manager.requestSerializer = requestSerializer;
        
        [responseSerializer.acceptableContentTypes insertValue:contentType inPropertyWithKey:@"Content-type"];
        manager.responseSerializer = responseSerializer;
    }
    
    [manager GET:requestURL parameters:parameters success:success failure:failure];
}

- (void)querySoftwareListAll {
    [self querySoftwareList:100 orderBy:nil];
}

- (void)querySoftwareList:(NSInteger)category orderBy:(NSString*)order {
    [self callApi:@"softwarelist" updateParameter:^(NSMutableDictionary* parameters) {
        [parameters setObject:@(category) forKey:@"no"];
        if (order) {
            [parameters setObject:@"order" forKey:order];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"XML: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)likeSoftware:(NSInteger)softId {
    [self callApi:@"likeapp" updateParameter:^(NSMutableDictionary* parameters) {
        [parameters setObject:@(softId) forKey:@"softid"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Total likes: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchImage:(NSString *)url {
    
}
/// NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
- (void)downloadFile:(NSString *)url toDirectory:(NSURL *)directoryURL {
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSProgress *progress = nil;
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [directoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

- (void)checkNetwork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Network Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

@end
