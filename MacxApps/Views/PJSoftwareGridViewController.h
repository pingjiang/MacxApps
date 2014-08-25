//
//  PJSoftwareGridViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PJSoftwareInfoParser.h"

@interface PJSoftwareGridViewController : NSViewController<NSCollectionViewDelegate, PJParseResultDelegate>

@property (weak) IBOutlet NSCollectionView *gridView;

@property (strong) NSMutableArray *items;

// Bind actions
- (IBAction)downloadButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo;
- (IBAction)detailButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo ;

// public methods
- (void)loadData;


@end
