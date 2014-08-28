//
//  PJListViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJListViewController.h"

@interface PJListViewController ()

@end

@implementation PJListViewController

@synthesize items, listIdentifier;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

/// TableView Delegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [self.tableView selectedRow];
    if (row >=0 && row < [self.items count]) {
        id obj = [self.arrayController.arrangedObjects objectAtIndex:row];
        [_selectionDelegate selectionDidChanged:self.listIdentifier withObject:obj];
    }
}

- (id<PJSelectionDelegate>)selectionDelegate {
    return _selectionDelegate;
}

- (void)setSelectionDelegate:(id<PJSelectionDelegate>)delegate {
    _selectionDelegate = delegate;
}


@end
