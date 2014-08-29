//
//  PJGeneralPreferenceViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJGeneralPreferenceViewController.h"

@interface PJGeneralPreferenceViewController ()

@end

@implementation PJGeneralPreferenceViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (NSImage *)toolbarItemImage
{
    return [NSImage imageNamed:NSImageNamePreferencesGeneral];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"General", @"Toolbar item name for the General preference pane");
}


@end
