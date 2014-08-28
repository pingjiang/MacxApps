//
//  PJSelectionDelegate.h
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PJSelectionDelegate <NSObject>

- (void)selectionDidChanged:(NSString*)selectableIdentifier withObject:(id)selectedObject;

@end
