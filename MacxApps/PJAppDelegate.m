//
//  PJAppDelegate.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJAppDelegate.h"
#import "PJSidebarViewController.h"

@interface PJAppDelegate ()

@property (strong, nonatomic) PJSidebarViewController *sidebarViewController;

- (void)registerDefaults;

@end

@implementation PJAppDelegate

- (void)registerDefaults {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MacxAppsDefaults" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void)awakeFromNib {
    // Initialize sidebar
    if (!self.sidebarViewController) {
        self.sidebarViewController = [[PJSidebarViewController alloc] init];
        [self.sidebarViewBox setContentView:self.sidebarViewController.view];
        [self.sidebarViewController setListViewBox:self.listViewBox];
        [self.sidebarViewController setDetailViewBox:self.detailViewBox];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self registerDefaults];
}


@end
