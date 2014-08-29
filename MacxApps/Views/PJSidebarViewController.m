//
//  PJSidebarViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSidebarViewController.h"
#import "PJTableCellView.h"
#import "PJListViewController.h"
#import "PJDetailViewController.h"
#import "PJSoftwareManager.h"
#import "PJAppsManager.h"

@interface PJSidebarViewController ()

- (void)loadSidebar;
- (void)changeViewFor:(NSString*)identifier;

// Sidebar - Softwares List
- (void)initializeSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;

// Sidebar - Macx News
- (void)initializeMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;

// Sidebar - Applications Management
- (void)initializeAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;


@end

@implementation PJSidebarViewController

@synthesize softwares = _softwares, macxNews = _macxNews, apps = _apps;
@synthesize listViewBox, detailViewBox;

- (void)loadSidebar {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sidebar" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    _sidebar = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Reading JSON file error: %@", error);
        return;
    }
}

- (void)changeViewFor:(NSString *)identifier {
    NSLog(@"Change view for %@", identifier);
    if (!_viewControllerCache) {
        _viewControllerCache = [[NSMutableDictionary alloc] init];
    }
    
    id cache = _viewControllerCache[identifier];
    id obj = nil;
    PJListViewController *listViewController = nil;
    PJDetailViewController *detailViewController = nil;
    if (!cache) {
        id _sidebarSysItems = _sidebar[@"items"][0][@"items"];
        NSUInteger i = [_sidebarSysItems indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if (![obj[@"identifier"] isEqualToString:identifier]) {
                return NO;
            }
            
            return YES;
        }];
        
        if (i == NSNotFound) {
            return;
        }
        
        obj = [_sidebarSysItems objectAtIndex:i];
        id listClass = NSClassFromString(obj[@"listViewControllerClassName"]);
        if (!listClass) {
            return;
        }
        listViewController = [[listClass alloc] init];
        if (!listViewController) {
            return;
        }
        id detailClass = NSClassFromString(obj[@"detailViewControllerClassName"]);
        if (!detailClass) {
            return;
        }
        detailViewController = [[detailClass alloc] init];
        if (!detailViewController) {
            return;
        }
        
        SEL viewControllerInitializer = NSSelectorFromString(obj[@"viewControllerInitializerSelectorName"]);
        if (!viewControllerInitializer) {
            return;
        }
        
        [listViewController setListIdentifier:identifier];
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:viewControllerInitializer withObject:listViewController withObject:detailViewController];
        
        cache = @[obj, listViewController, detailViewController];
        [_viewControllerCache setObject:cache forKey:identifier];
    } else {
        obj = cache[0];
        listViewController = cache[1];
        detailViewController = cache[2];
    }
    
    SEL viewControllerUpdater = NSSelectorFromString(obj[@"viewControllerUpdaterSelectorName"]);
    if (!viewControllerUpdater) {
        return;
    }
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:viewControllerUpdater withObject:listViewController withObject:detailViewController];
    
    [self.listViewBox setContentView:listViewController.view];
    [self.detailViewBox setContentView:_defaultView];
}

- (void)initializeSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"initializeSoftwareList %@ %@", listViewController, detailViewController);
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    if (!_softwares) {
        [self setSoftwares:[[NSMutableArray alloc] init]];
    }
    [[PJSoftwareManager sharedManager] querySoftwareListAll:^(id obj) {
        PJSoftwareInfoParser *_parser = [[PJSoftwareInfoParser alloc] initWithData:obj];
        [_parser setResultDelegate:self];
        [_parser setTargetObject:listViewController];
        //[_parser setNeedDebug:YES];
        [_parser parse];
    }];
}
- (void)updateSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"updateSoftwareList %@ %@", listViewController, detailViewController);
}

- (void)initializeMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"initializeMacxNewsList %@ %@", listViewController, detailViewController);
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    [[PJSoftwareManager sharedManager]  queryMacxNews:^(id responseObject) {
        NSError *error = nil;
        _rawMacxNewsJsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"Decode JSON error: %@", error);
            [self setMacxNews:@[]];
            return;
        }
        
        [self setMacxNews:_rawMacxNewsJsonObject[@"Variables"][@"forum_threadlist"]];
        [listViewController setItems:self.macxNews];
    }];
}

- (void)updateMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"updateMacxNewsList %@ %@", listViewController, detailViewController);
}


- (void)initializeAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"initializeAppsList %@ %@", listViewController, detailViewController);
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    [self setApps:[[PJAppsManager sharedManager] findApps]];
    [listViewController setItems:self.apps];
}

- (void)updateAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    NSLog(@"updateAppsList %@ %@", listViewController, detailViewController);
}


- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self loadSidebar];
    }
    return self;
}

- (void)awakeFromNib {
    //[self changeViewFor:_sidebar[@"items"][0][@"identifier"]];
    
    if (!_defaultView) {
        _defaultView = [self.detailViewBox contentView];
    }
}

#pragma mark - OutlineView DataSource
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return [_sidebar[@"items"] count];
    }
    
    return [item[@"items"] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return _sidebar[@"items"][index];
    }
    
    return item[@"items"][index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if ([item objectForKey:@"items"]) {
        return YES;
    }
    return NO;
}

#pragma mark - OutlineView Delegate
- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    PJTableCellView *view = nil;
    if ([item objectForKey:@"items"]) {
        view = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    }
    
    NSString *identifier = item[@"identifier"];
    if (!identifier) {
        [view setIdentifier:identifier];
    }
    [view setRepresentedObject:item];
    
    return view;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    for (id sidebarItem in _sidebar[@"items"]) {
        if (item == sidebarItem) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return ![self outlineView:outlineView isGroupItem:item];
}
- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSOutlineView *outlineView = notification.object;
    id itemAtRow = [outlineView itemAtRow:outlineView.selectedRow];
    NSString *identifier = itemAtRow[@"identifier"];
    if (identifier) {
        NSLog(@"Change sys sidebar items %@", identifier);
        [self changeViewFor:identifier];
    } else {
        NSString *cid = itemAtRow[@"cid"];
        if (cid) {
            NSLog(@"Change software categories %@", cid);
        }
    }
}


#pragma mark - ParseResult Delegate
- (void)didBeginParseResult {
    NSLog(@"Enter %s", __PRETTY_FUNCTION__);
}

- (BOOL)didParseResult:(NSDictionary *)nodeInfo {
    [_softwares addObject:nodeInfo];
    return NO;
}

- (BOOL)onParseResultError:(NSError*)error {
    NSLog(@"onParseResultError %@", error);
    return YES;
}
- (void)didParseResultDone:(PJSoftwareInfoParser*)parser {
    NSLog(@"Enter %s", __PRETTY_FUNCTION__);
    [parser.targetObject setItems:_softwares];
}


/// Selection Delegate
- (void)selectionDidChanged:(NSString*)selectableIdentifier withObject:(id)selectedObject {
    if (!selectedObject) {
        return;
    }
    id cache = _viewControllerCache[selectableIdentifier];
    if (!cache) {
        return;
    }
    
    PJDetailViewController *detailViewController = cache[2];
    [self.detailViewBox setContentView:detailViewController.view];
    
    if (detailViewController.representedObject != selectedObject) {
        [detailViewController setRepresentedObject:selectedObject];
    }
}

@end
