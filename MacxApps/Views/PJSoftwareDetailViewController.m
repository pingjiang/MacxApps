//
//  PJSoftwareDetailViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareDetailViewController.h"

@interface PJSoftwareDetailViewController ()

@end

@implementation PJSoftwareDetailViewController


- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


@end


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