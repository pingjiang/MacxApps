//
//  PJAppDelegate.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"
#import "PJSoftwareInfoParser.h"
#import "PJSoftwareListViewController.h"

@class PJSoftwareGridViewController;
@class PJSoftwareListViewController;
@class PJSoftwareDetailViewController;

@interface PJAppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate, PJParseResultDelegate, PJSelectionDelegate> {
    NSView *_defaultView;
    NSView *_keyView;
    PJSoftwareGridViewController *_softwareGridViewController;
    PJSoftwareListViewController *_softwareListViewController;
    PJSoftwareDetailViewController *_softwareDetailViewController;
}

@property (strong) NSMutableArray *items;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *splitView;

@property (weak) IBOutlet PXSourceList *sourceList;
@property (weak) IBOutlet NSBox *middleViewBox;
@property (weak) IBOutlet NSBox *viewBox;
@property (weak) IBOutlet NSButtonCell *removeButton;


- (IBAction)addButtonAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;


@end
