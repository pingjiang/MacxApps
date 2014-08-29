//
//  PJAdvancedPreferenceViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJAdvancedPreferenceViewController.h"

@interface PJAdvancedPreferenceViewController ()

@end

@implementation PJAdvancedPreferenceViewController

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
    return [NSImage imageNamed:NSImageNameAdvanced];
}

- (NSString *)toolbarItemLabel
{
    return NSLocalizedString(@"Advanced", @"Toolbar item name for the Advanced preference pane");
}

- (NSView *)initialKeyView
{
    NSInteger focusedControlIndex = [[NSApp valueForKeyPath:@"delegate.focusedAdvancedControlIndex"] integerValue];
    return (focusedControlIndex == 0 ? self.textField : self.tableView);
}

@end
