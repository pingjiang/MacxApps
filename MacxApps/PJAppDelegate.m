//
//  PJAppDelegate.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJAppDelegate.h"
#import "PJSidebarViewController.h"
#import "MASPreferencesWindowController.h"
#import "PJGeneralPreferenceViewController.h"
#import "PJAdvancedPreferenceViewController.h"

@interface PJAppDelegate ()

@property (strong, nonatomic) PJSidebarViewController *sidebarViewController;

- (void)registerDefaults;

@end

@implementation PJAppDelegate

@synthesize preferencesWindowController = _preferencesWindowController;

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

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

#pragma mark - Public accessors

- (NSWindowController *)preferencesWindowController
{
    if (_preferencesWindowController == nil)
    {
        NSViewController *generalViewController = [[PJGeneralPreferenceViewController alloc] init];
        NSViewController *advancedViewController = [[PJAdvancedPreferenceViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, advancedViewController, nil];
        
        // To add a flexible space between General and Advanced preference panes insert [NSNull null]:
        //     NSArray *controllers = [[NSArray alloc] initWithObjects:generalViewController, [NSNull null], advancedViewController, nil];
        
        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}

#pragma mark - Actions

- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}

#pragma mark -

NSString *const kFocusedAdvancedControlIndex = @"FocusedAdvancedControlIndex";

- (NSInteger)focusedAdvancedControlIndex
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kFocusedAdvancedControlIndex];
}

- (void)setFocusedAdvancedControlIndex:(NSInteger)focusedAdvancedControlIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:focusedAdvancedControlIndex forKey:kFocusedAdvancedControlIndex];
}

@end
