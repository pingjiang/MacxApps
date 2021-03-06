//
//  PJSidebarViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PJSoftwareInfoParser.h"
#import "PJSelectionDelegate.h"
#import "PJListViewController.h"

@interface PJSidebarViewController : NSViewController<NSOutlineViewDataSource, NSOutlineViewDelegate, PJParseResultDelegate, PJSelectionDelegate> {
    id _sidebar;
    NSView *_defaultView;
    NSMutableDictionary *_viewControllerCache;
    NSMutableDictionary *_categoryCache;
    id _rawMacxNewsJsonObject;
}

@property (weak) IBOutlet NSOutlineView *sidebarView;

@property (strong) NSMutableArray *softwares;
@property (weak) NSArray *macxNews;
@property (weak) NSArray *apps;

@property (weak, nonatomic) NSBox *listViewBox;
@property (weak, nonatomic) NSBox *detailViewBox;

- (void)changeToKeyView;
- (void)changeViewFor:(NSString*)identifier;

- (PJListViewController*)keyListViewController;

@end
