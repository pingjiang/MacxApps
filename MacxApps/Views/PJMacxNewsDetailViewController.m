//
//  PJMacxNewsDetailViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJMacxNewsDetailViewController.h"

@interface PJMacxNewsDetailViewController ()

@end

@implementation PJMacxNewsDetailViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (IBAction)moreButtonAction:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://www.macx.cn/thread-%@-1-1.html", self.representedObject[@"tid"]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
}
@end
