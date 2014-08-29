//
//  PJAdvancedPreferenceViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"

@interface PJAdvancedPreferenceViewController : NSViewController<MASPreferencesViewController>

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTableView *tableView;


@end
