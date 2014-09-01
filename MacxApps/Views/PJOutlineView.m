//
//  PJOutlineView.m
//  MacxApps
//
//  Created by 平江 on 14-8-30.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJOutlineView.h"

@implementation PJOutlineView

- (void)reloadData {
    [super reloadData];
    
    // Always expand item under root
    for(NSUInteger i=0;i<[self.dataSource outlineView:self numberOfChildrenOfItem:nil];i++)
    {
        id item = [self.dataSource outlineView:self child:i ofItem:nil];
        [self expandItem:item];
    }
}

@end
