//
//  PJSoftwareListViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PJSelectionDelegate.h"
#import "PJListViewController.h"
#import "ITPullToRefreshScrollView.h"

@interface PJSoftwareListViewController : PJListViewController<ITPullToRefreshScrollViewDelegate>

@property (weak) IBOutlet ITPullToRefreshScrollView *scrollView;

- (id)initWithFrame:(NSRect)frameRect;

@end
