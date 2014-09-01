//
//  PJSoftwareListViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareListViewController.h"
#import "PJMacxClient.h"

@interface PJSoftwareListViewController ()

@end

@implementation PJSoftwareListViewController

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
    [self.scrollView setDelegate:self];
    // Make top & bottom refreshable
    self.scrollView.refreshableEdges = ITPullToRefreshEdgeTop | ITPullToRefreshEdgeBottom;
}

#pragma mark - PullToRefresh Delegate
/**
 *  This method get's invoked when the scroll view started refreshing
 *
 *  @param scrollView - The scroll view that started refreshing
 *  @param edge       - The edge that started refreshing
 */
- (void)pullToRefreshView:(ITPullToRefreshScrollView *)scrollView
   didStartRefreshingEdge:(ITPullToRefreshEdge)edge {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillLoadMacxSoftwares object:self userInfo:@{@"listViewController": self}];
    
    // Don't forget to call this line!
    [scrollView stopRefreshingEdge:edge];
}

/**
 *  This method get's invoked when the scroll view stopped refreshing
 *
 *  @param scrollView - The scroll view that stopped refreshing
 *  @param edge       - The edge that stopped refreshing
 */
- (void)pullToRefreshView:(ITPullToRefreshScrollView *)scrollView
    didStopRefreshingEdge:(ITPullToRefreshEdge)edge {
    
    // Do UI stuff
}

@end
