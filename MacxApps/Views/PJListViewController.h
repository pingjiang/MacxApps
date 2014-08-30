//
//  PJListViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PJSelectionDelegate.h"

@interface PJListViewController : NSViewController<NSTableViewDelegate> {
    id _selectionDelegate;
}

@property (weak) NSArray *items;
@property (weak) NSString *listIdentifier;

@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) IBOutlet NSTableView *tableView;

- (id<PJSelectionDelegate>)selectionDelegate;
- (void)setSelectionDelegate:(id<PJSelectionDelegate>)delegate;

- (void)rearrangeArrayControllerItems;

@end
