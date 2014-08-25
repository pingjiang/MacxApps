//
//  PJAppDelegate.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PXSourceList.h"

@interface PJAppDelegate : NSObject <NSApplicationDelegate, PXSourceListDataSource, PXSourceListDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet PXSourceList *sourceList;
@property (weak) IBOutlet NSTextField *selectedItemLabel;
@property (weak) IBOutlet NSButtonCell *removeButton;


- (IBAction)addButtonAction:(id)sender;
- (IBAction)removeButtonAction:(id)sender;


@end
