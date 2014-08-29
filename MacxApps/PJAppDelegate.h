//
//  PJAppDelegate.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PJSoftwareInfoParser.h"
#import "PJSelectionDelegate.h"

@interface PJAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *splitView;

@property (weak) IBOutlet NSBox *sidebarViewBox;
@property (weak) IBOutlet NSBox *listViewBox;
@property (weak) IBOutlet NSBox *detailViewBox;

@end
