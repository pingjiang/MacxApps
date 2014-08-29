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
    static NSDateFormatter *dateFormatter0 = nil;
    static NSDateFormatter *dateFormatter1 = nil;
    if (!dateFormatter0) {
        dateFormatter0 = [[NSDateFormatter alloc] init];
        [dateFormatter0 setDateFormat:@"yy-MM-dd HH:mm:ss"];// yyyy-MM-dd 'at' HH:mm
        
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];// yyyy-MM-dd 'at' HH:mm
    }
    
    NSDate *date = [dateFormatter0 dateFromString:dateLine];
    return [dateFormatter1 stringFromDate:date];
}

@end

@implementation PJAppsDateValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

// <span title="14-8-25 19:00:56">3&nbsp;\u5c0f\u65f6\u524d</span>
- (id)transformedValue:(id)value {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];// yyyy-MM-dd 'at' HH:mm
    }
    
    return [dateFormatter stringFromDate:value];
}

@end


/// Timestamp transfomer
@implementation PJTimestampValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
    static NSDateFormatter *dateFormatterTimestamp = nil;
    if (!dateFormatterTimestamp) {
        dateFormatterTimestamp = [[NSDateFormatter alloc] init];
        [dateFormatterTimestamp setDateFormat:@"yyyy-MM-dd"];// yyyy-MM-dd 'at' HH:mm
    }
    
    return [dateFormatterTimestamp stringFromDate:date];
}

@end


