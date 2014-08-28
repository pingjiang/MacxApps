//
//  PJSoftwareCategory.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJSoftwareCategory : NSObject{
    id _jsonObject;
    NSArray *_items;
}

@property (nonatomic, readonly) NSInteger cid;
@property (nonatomic, weak, readonly) NSString *name;
@property (nonatomic, weak, readonly) NSArray *items;

+ (instancetype)categoryFromFile:(NSString *)filePath;

- (NSInteger)numberOfChildren;
- (id)itemAtIndex:(NSInteger)index;



@end
