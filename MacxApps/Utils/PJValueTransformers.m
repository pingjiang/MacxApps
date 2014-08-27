//
//  PJValueTransformers.m
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJValueTransformers.h"
#import "NSString+PJAdditions.h"

@implementation PJArrayValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if ([value isKindOfClass:[NSArray class]]) {
        return [value componentsJoinedByString:@", "];
    }
    
    return [value description];
}

@end


/// Macx News URL transfomer
@implementation PJMacxNewsURLValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    return [NSString stringWithFormat:@"http://www.macx.cn/%@", value];
}

@end


/// Macx News DateLine transfomer
@implementation PJMacxNewsDateLineValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

// <span title="14-8-25 19:00:56">3&nbsp;\u5c0f\u65f6\u524d</span>
- (id)transformedValue:(id)value {
    if (!value) {
        return value;
    }
    NSString *dateLine = [value substringWithBound:@"\"" withBound:@"\"" options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];// yyyy-MM-dd 'at' HH:mm
    NSDate *date = [dateFormatter dateFromString:dateLine];
    return [date description];
}

@end


