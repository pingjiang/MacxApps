//
//  PJSoftwareGridViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareGridViewController.h"

@interface PJSoftwareGridViewController ()

@end

@implementation PJSoftwareGridViewController

@synthesize items = _items;

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        NSLog(@"%@ init", [self className]);
    }
    
    return self;
}

- (void)awakeFromNib {
    NSLog(@"%@ awakeFromNib", [self className]);
    // [self.gridView setBackgroundColors:@[]];
}

- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"macx-softlist" ofType:@"xml"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    PJSoftwareInfoParser *_parser = [[PJSoftwareInfoParser alloc] initWithData:data];
    [_parser setResultDelegate:self];
    //[_parser setNeedDebug:YES];
    [_parser parse];
}

#pragma mark - ParseResult Delegate
- (void)didBeginParseResult {
    if (!_items) {
        [self setItems:[[NSMutableArray alloc] init]];
    }
}

- (void)didParseResult:(NSDictionary *)nodeInfo {
    [self willChangeValueForKey:@"items"];
    [_items addObject:nodeInfo];
    [self didChangeValueForKey:@"items"];
    
    // [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[_softwareList count] - 1] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}
- (void)onParseResultError:(NSError*)error {
    NSLog(@"onParseResultError %@", error);
}
- (void)didParseResultDone {
    // NSLog(@"didParseResultDone");
    //[self.tableView reloadData];
}


- (IBAction)downloadButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo {
    NSLog(@"downloadButtonAction %@, software info: %@", sender, softwareInfo);
    
    // TODO 这样需要先选中然后才能点击按钮。我希望的是能够直接点击按钮
    NSIndexSet *indexes = [self.gridView selectionIndexes];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSCollectionViewItem *viewItem = [self.gridView itemAtIndex:idx];
        id obj = [viewItem representedObject];
        NSLog(@"selected %ld %@", idx, obj);
    }];
}

- (IBAction)detailButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo {
    NSLog(@"detailButtonAction %@, software info: %@", sender, softwareInfo);
}

@end
