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

@interface PJSidebarViewController : NSViewController<NSOutlineViewDataSource, NSOutlineViewDelegate,
    PJParseResultDelegate, PJSelectionDelegate> {
    id _sidebar;
    NSView *_defaultView;
    NSMutableDictionary *_viewControllerCache;
    id _rawMacxNewsJsonObject;
}

@property (weak) IBOutlet NSOutlineView *sidebarView;

@property (strong, nonatomic) NSMutableArray *softwares;
@property (weak, nonatomic) NSArray *macxNews;
@property (weak, nonatomic) NSArray *apps;

@property (weak, nonatomic) NSBox *listViewBox;
@property (weak, nonatomic) NSBox *detailViewBox;


- (void)changeViewFor:(NSString*)identifier;

@end
