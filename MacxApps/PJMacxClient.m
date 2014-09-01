//
//  PJMacxClient.m
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJMacxClient.h"
#import "PJPreferences.h"

static NSString *const MacxBaseURLString = @"http://soft.macx.cn";
static NSString *const kSoftwareListProviders = @"SoftwareListProviders";
static NSString *const kImageDidLoadNotification = @"org.pj.MacxApps-image.loaded";

// Notications
NSString *const kWillLoadMacxSoftwares = @"WillLoadMacxSoftwares";
NSString *const kShouldQueryMacxSoftwares = @"ShouldQueryMacxSoftwares";
NSString *const kShouldUpdateMacxSoftwares = @"ShouldUpdateMacxSoftwares";
NSString *const kShouldParseMacxSoftwares = @"ShouldParseMacxSoftwares";
NSString *const kDidQueryMacxSoftwares = @"DidQueryMacxSoftwares";
NSString *const kDidUpdateMacxSoftwares = @"DidUpdateMacxSoftwares";
NSString *const kDidParseMacxSoftwares = @"DidParseMacxSoftwares";

@interface PJMacxClient ()

+ (id)defaultSoftwareListProvider;

- (void)callApi:(NSString*)name updateParameter:(void (^)(NSMutableDictionary*))updateParameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

@implementation PJMacxClient

+ (void)initializeNetwork {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

+ (instancetype)sharedClient {
    static PJMacxClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PJMacxClient alloc] init];
        // NO SSL
        // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

+ (id)defaultSoftwareListProvider {
    NSArray *providers = [[NSUserDefaults standardUserDefaults] arrayForKey:kSoftwareListProviders];
    NSDictionary *provider = [providers firstObject];
    return provider;
}

// 根据配置获取不同接口的描述信息
- (void)callApi:(NSString *)name updateParameter:(void (^)(NSMutableDictionary*))updateParameter success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    NSDictionary *provider = [[self class] defaultSoftwareListProvider];
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
    
    if (contentType) {
        AFHTTPResponseSerializer *httpResponseSerializer = [AFHTTPResponseSerializer serializer];
        
        // text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
        // NSString *ua = @"Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25";
        // [requestSerializer setValue:ua forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:contentType forHTTPHeaderField:@"Content-type"];
        
        [httpResponseSerializer.acceptableContentTypes insertValue:contentType inPropertyWithKey:@"Content-type"];
        [self setResponseSerializer:httpResponseSerializer];
    }
    
    [self GET:requestURL parameters:parameters success:success failure:failure];
}

- (void)querySoftwareListAll:(void (^)(id obj))responseWith {
    NSInteger num = [[NSUserDefaults standardUserDefaults] integerForKey:kSoftwaresNumbersPerRequest];
    [self querySoftwareList:num orderBy:nil responseWith:responseWith];
}

- (void)querySoftwareList:(NSInteger)category orderBy:(NSString*)order responseWith:(void (^)(id obj))responseWith {
    [self callApi:@"softwarelist" updateParameter:^(NSMutableDictionary* parameters) {
        if (category > 0) {
            [parameters setObject:@(category) forKey:@"no"];
        }
        if (order) {
            [parameters setObject:order forKey:@"order"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

- (void)likeSoftware:(NSInteger)softId responseWith:(void (^)(id obj))responseWith {
    [self callApi:@"likeapp" updateParameter:^(NSMutableDictionary* parameters) {
        [parameters setObject:@(softId) forKey:@"softid"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

//"tid": "2137517",
//"readperm": "0",
//"author": "-",
//"authorid": "8",
//"subject": "iPhone 6\u7684 M7\u8fd0\u52a8\u534f\u5904\u7406\u5668\u88ab\u79f0\u4e3a Phosphorus\uff08\u78f7\uff09",
//"dateline": "<span title=\"14-8-25 19:00:56\">3&nbsp;\u5c0f\u65f6\u524d<\/span>",
//"lastpost": "<span title=\"14-8-25 21:50:53\">21&nbsp;\u5206\u949f\u524d<\/span>",
//"lastposter": "wt303474",
//"views": "1319",
//"replies": "10",
//"attachment": "2",
//"dbdateline": "1408964456",
//"dblastpost": "1408974653",
//"img": "data\/attachment\/forum\/201408\/25\/190046a0t9piiv70fl977o.jpg"
//
//
//@"tid", @"author", @"subject", @"views", @"img", @"attachment", @"dateline"
- (void)queryMacxNews:(void (^)(id responseObject))responseWith {
    [self callApi:@"macxnews" updateParameter:^(NSMutableDictionary* parameters) {
        NSInteger dateline = [[NSUserDefaults standardUserDefaults] integerForKey:kDatelineDaysForMacxNews] * 86400;
        [parameters setObject:@(dateline) forKey:@"dateline"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

- (void)totalNumbers:(void (^)(id responseObject))responseWith {
    [self callApi:@"totalNumbers" updateParameter:^(NSMutableDictionary* parameters) {
        // None
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

- (void)queryAllSoftwares:(void (^)(id responseObject))responseWith {
    [self callApi:@"queryAllSoftwares" updateParameter:^(NSMutableDictionary* parameters) {
        // None
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

/*
 
 <meta http-equiv="Content-Type" content="text/html; charset=GB18030">
 
 <ul><li><a href=/2551.htm>Apple Remote Desktop&nbsp 3.7.2</a></li><li><a href=/4995.htm>Apple Xcode &nbsp 5.1</a></li><li><a href=/3014.htm>Apple iTunes&nbsp 11.1.4</a></li><li><a href=/5093.htm>Grappler &nbsp 1.0.9</a></li><li><a href=/1384.htm>Apple iPhoto &nbsp 9.4.3</a></li><li><a href=/5280.htm>Seas0nPass 0.88 Apple TV 越狱&nbsp 0.88</a></li><li><a href=/4470.htm>Apple Motion&nbsp 5.0.5</a></li><li><a href=/5144.htm>Apple Numbers &nbsp 2.2</a></li><li><a href=/2173.htm>Apple Keynote &nbsp 5.2</a></li><li><a href=/2174.htm>Apple Pages &nbsp 4.2</a></li></ul>
 */
- (void)ajaxSearch:(NSString*)keyword responseWith:(void (^)(id obj))responseWith {
    [self callApi:@"ajaxSearch" updateParameter:^(NSMutableDictionary* parameters) {
        if (keyword) {
            [parameters setObject:keyword forKey:@"keyword"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        responseWith(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        responseWith(nil);
    }];
}

/// NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
+ (void)downloadFile:(NSString *)url toDirectory:(NSURL *)directoryURL {
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSProgress *progress = nil;
    
    AFURLSessionManager *_manager = [[AFURLSessionManager alloc] init];
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [directoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

+ (void)checkNetwork {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Network Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

- (AFHTTPRequestOperation *)fetchImage:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure cacheBlock:(NSCachedURLResponse * (^)(NSURLConnection *connection, NSCachedURLResponse *cachedResponse))cacheBlock
{
    [self.requestSerializer setValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self setResponseSerializer:[AFImageResponseSerializer serializer]];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    if (cacheBlock) {
        [operation setCacheResponseBlock:cacheBlock];
    }
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

// [[NSNotificationCenter defaultCenter] postNotificationName:kImageDidLoadNotification object:self userInfo:nil];
// [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];

// http://pan.baidu.com/s/1bntQTsV 302
// http://pan.baidu.com/share/init?shareid=3469212407&uk=369186934
// POST
// http://pan.baidu.com/share/verify?shareid=3469212407&uk=369186934&t=1409406778067&channel=chunlei&clienttype=0&web=1
// pwd:i652, vcode:
- (AFHTTPRequestOperation *)prefetchRedirectURL:(NSString *)URLString
                            parameters:(id)parameters
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure redirectBlock:(NSURLRequest * (^)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse))redirectBlock
{
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[@"i652" dataUsingEncoding:NSASCIIStringEncoding]  name:@"pwd"];
        [formData appendPartWithFormData:[@"" dataUsingEncoding:NSASCIIStringEncoding] name:@"vcode"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end