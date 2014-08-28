//
//  NSString+PJAdditions.m
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "NSString+PJAdditions.h"

@implementation NSString (PJAdditions)

/// 根据字符串左右两边的边界提取字符串
- (NSString*)substringWithBound:(NSString*)lbound withBound:(NSString*)rbound options:(NSStringCompareOptions)mask {
    NSRange lfound = [self rangeOfString:lbound options:mask];
    if (lfound.location == NSNotFound) {
        return self;
    }
    NSRange remainRange = NSMakeRange(lfound.location + [lbound length], [self length]);
    remainRange.length -= remainRange.location;
    NSRange rfound = [self rangeOfString:rbound options:mask range:remainRange];
    if (rfound.location == NSNotFound) {
        return self;
    }
    
    NSRange foundRange = NSMakeRange(remainRange.location, rfound.location);
    foundRange.length -= foundRange.location;
    return [self substringWithRange:foundRange];
}

@end
