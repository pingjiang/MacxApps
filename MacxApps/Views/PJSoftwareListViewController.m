//
//  PJSoftwareListViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareListViewController.h"

@interface PJSoftwareListViewController ()

@end

@implementation PJSoftwareListViewController

@synthesize items;

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self.view setFrame:frameRect];
    }
    return self;
}


@end
