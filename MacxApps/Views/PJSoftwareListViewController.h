//
//  PJSoftwareListViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PJSelectionDelegate <NSObject>

- (void)selectionDidChanged:(id)selectedObject;

@end

@interface PJSoftwareListViewController : NSViewController<NSTableViewDelegate> {
    id _selectionDelegate;
}

@property (weak) NSArray *items;

@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) IBOutlet NSTableView *tableView;


- (id)initWithFrame:(NSRect)frameRect;

- (id<PJSelectionDelegate>)selectionDelegate;
- (void)setSelectionDelegate:(id<PJSelectionDelegate>)delegate;

@end
