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

- (void)awakeFromNib {
    NSLog(@"%@ awakeFromNib", [self className]);
    // [self.tableView setAction:@selector(doAction:)];
    // NSColor *bgColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"BackgroundDust"]];
    // [self.tableView setBackgroundColor:bgColor];
}


/// TableView Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSLog(@"SelectionDidChange %@", notification);
    NSInteger row = [self.tableView selectedRow];
    // id cellObj = [[self.tableView selectedCell] representedObject];
    // NSLog(@"selected cell: %@", cellObj);// null
    // [self.arrayController content]
    if (row >=0 && row < [self.items count]) {
        id obj = [self.arrayController.arrangedObjects objectAtIndex:row];
        NSLog(@"tableView selectionDidChange: %@", obj);
        [_selectionDelegate selectionDidChanged:obj];
    }
}

- (id<PJSelectionDelegate>)selectionDelegate {
    return _selectionDelegate;
}

- (void)setSelectionDelegate:(id<PJSelectionDelegate>)delegate {
    _selectionDelegate = delegate;
}

@end
