//
//  PJUtils.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJUtils.h"

@implementation PJUtils

+ (NSString *)convertTimestamp:(NSString *)timestamp withFormat:(NSString*)format {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];// yyyy-MM-dd 'at' HH:mm
    return [dateFormatter stringFromDate:date];
}

@end
