//
//  PJSoftwareCategory.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareCategory.h"


@interface PJSoftwareCategory ()

- (id)init;
- (id)initWithJsonObject:(id)jsonObject;

@end

@implementation PJSoftwareCategory

- (id)init {
    return [self initWithJsonObject:nil];
}

- (id)initWithJsonObject:(id)jsonObject {
    if (self = [super init]) {
        _jsonObject = jsonObject;
    }
    
    return self;
}

+ (instancetype)categoryFromFile:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Reading JSON file error: %@", error);
        return nil;
    }
    
    return [[PJSoftwareCategory alloc] initWithJsonObject:jsonObj];
}

- (NSInteger)cid {
    if (!_jsonObject) {
        return 0;
    }
    
    return [_jsonObject[@"cid"] integerValue];
}

- (NSString *)name {
    if (!_jsonObject) {
        return nil;
    }
    
    return _jsonObject[@"name"];
}

- (NSArray *)items {
    if (!_jsonObject) {
        return @[];
    }
    if (!_items) {
        NSArray *subItems = _jsonObject[@"items"];
        if (!subItems) {
            _items = @[];
        }
        
        NSMutableArray *subCategories = [[NSMutableArray alloc] initWithCapacity:[subItems count]];
        for (id subItem in subItems) {
            [subCategories addObject:[[PJSoftwareCategory alloc] initWithJsonObject:subItem]];
        }
        
        _items = subCategories;
    }
    
    return _items;
}

- (NSInteger)numberOfChildren {
    return [self.items count];
}

- (id)itemAtIndex:(NSInteger)index {
    return [self.items objectAtIndex:index];
}

@end
