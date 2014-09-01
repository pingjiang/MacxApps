//
//  NSData+PJAdditions.m
//  MacxApps
//
//  Created by 平江 on 14-8-31.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "NSData+PJAdditions.h"


@implementation NSData (PJAdditions)

- (NSInteger)integerValue {
    NSString *num = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    if (num) {
        return [num integerValue];
    }
    
    return 0;
}

@end
