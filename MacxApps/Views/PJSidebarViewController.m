//
//  PJSidebarViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-29.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSidebarViewController.h"
#import "PJTableCellView.h"
#import "PJDetailViewController.h"
#import "PJSoftwareListViewController.h"
#import "PJMacxClient.h"
#import "PJAppsManager.h"
#import "NSData+PJAdditions.h"
#import "TMCache/TMCache.h"

@interface PJSidebarViewController ()

- (void)loadSidebar;
- (NSArray*)categoryNameForId:(NSString*)cid;

// Sidebar - Softwares List
- (void)initializeSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;

// Sidebar - Macx News
- (void)initializeMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;

// Sidebar - Applications Management
- (void)initializeAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;
- (void)updateAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController;

- (void)willLoadMacxSoftwares:(NSNotification *)notification;
- (void)shouldQueryMacxSoftwares:(NSNotification *)notification;
- (void)shouldParseMacxSoftwares:(NSNotification *)notification;
- (void)didParseMacxSoftwares:(NSNotification *)notification;

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
    
    _categoryCache = [[NSMutableDictionary alloc] init];
    id userItems = _sidebar[@"items"][1][@"items"];
    for (id userItem in userItems) {
        NSString *cid = userItem[@"cid"];
        NSString *name = userItem[@"name"];
        
        if (!cid || !name) {
            continue;
        }
        
        NSMutableArray *namesArray = [NSMutableArray array];
        [namesArray addObject:name];
        
        for (id subUserItem in userItem[@"items"]) {
            NSString *scid = subUserItem[@"cid"];
            NSString *sname = subUserItem[@"name"];
            
            if (!scid || !sname) {
                continue;
            }
            [namesArray addObject:sname];
            
            _categoryCache[scid] = @[sname];
        }
        
        _categoryCache[cid] = namesArray;
    }
}

- (NSArray *)categoryNameForId:(NSString *)cid {
    return [_categoryCache objectForKey:cid];
}

- (void)changeToKeyView {
    [self changeViewFor:@"AllSoftwares"];
}

- (PJListViewController *)keyListViewController {
    return _viewControllerCache[@"AllSoftwares"][1];
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


- (void)willLoadMacxSoftwares:(NSNotification *)notification {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
    
    PJListViewController* listViewController = notification.userInfo[@"listViewController"];
    NSNumber *isInitialize = notification.userInfo[@"init"];
    
    NSNumber *oldSoftwaresNumbers = [[TMCache sharedCache] objectForKey:@"softwaresNumber"];
    [[PJMacxClient sharedClient] totalNumbers:^(id responseObject) {
        NSNumber *softwaresNumbers = responseObject;
        [[TMCache sharedCache] setObject:softwaresNumbers forKey:@"softwaresNumber"];
        
        NSInteger newNum = [softwaresNumbers integerValue];
        NSInteger oldNum = [oldSoftwaresNumbers integerValue];
        NSInteger diffNum = newNum - oldNum;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldQueryMacxSoftwares object:self userInfo:@{@"init": isInitialize ? isInitialize : @(0), @"count": @(diffNum), @"listViewController": listViewController}];
    }];
}

- (void)shouldQueryMacxSoftwares:(NSNotification *)notification {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
    PJListViewController* listViewController = notification.userInfo[@"listViewController"];
    NSInteger count = [notification.userInfo[@"count"] integerValue];
    id data = [[TMCache sharedCache] objectForKey:@"softwares"];
    if (count > 0 || !data) {
        //querySoftwareListAll
        [[PJMacxClient sharedClient] queryAllSoftwares:^(id obj) {
            if (!obj) {
                return;
            }
            
            if ([_softwares count] > 0) {
                [_softwares removeAllObjects];
            }
            
            [[TMCache sharedCache] setObject:obj forKey:@"softwares"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kShouldParseMacxSoftwares object:self userInfo:@{@"listViewController": listViewController, @"data": obj}];
        }];
        
        return;
    }
    
    // 只有首次启动才加载
    NSNumber *isInitialize = notification.userInfo[@"init"];
    if (isInitialize && [isInitialize integerValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldParseMacxSoftwares object:self userInfo:@{@"listViewController": listViewController, @"data": data}];
    }
}

- (void)shouldParseMacxSoftwares:(NSNotification *)notification {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
    PJListViewController* listViewController = notification.userInfo[@"listViewController"];
    id data = notification.userInfo[@"data"];
    
    PJSoftwareInfoParser *_parser = [[PJSoftwareInfoParser alloc] initWithData:data];
    [_parser setResultDelegate:self];
    [_parser setTargetObject:listViewController];
    //[_parser setNeedDebug:YES];
    [_parser parse];
}
- (void)didParseMacxSoftwares:(NSNotification *)notification {
    //NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
}

- (void)initializeSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    if (!_softwares) {
        [self setSoftwares:[[NSMutableArray alloc] init]];
        [listViewController setItems:self.softwares];
    }
    
    //[NSThread detachNewThreadSelector:@selector(parseAndLoadSoftwares:) toTarget:self withObject:listViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillLoadMacxSoftwares object:self userInfo:@{@"listViewController": listViewController, @"init":@(1)}];
}
- (void)updateSoftwareList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    [listViewController filterWithCategory:nil];
}

- (void)initializeMacxNewsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    [[PJMacxClient sharedClient]  queryMacxNews:^(id responseObject) {
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
    //NSLog(@"updateMacxNewsList %@ %@", listViewController, detailViewController);
}


- (void)initializeAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    [listViewController setSelectionDelegate:self];
    
    [self.listViewBox setContentView:listViewController.view];
    
    [self setApps:[[PJAppsManager sharedManager] findApps]];
    [listViewController setItems:self.apps];
}

- (void)updateAppsList:(PJListViewController*)listViewController andDetail:(PJDetailViewController*)detailViewController {
    //NSLog(@"updateAppsList %@ %@", listViewController, detailViewController);
}

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        [self loadSidebar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willLoadMacxSoftwares:) name:kWillLoadMacxSoftwares object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldQueryMacxSoftwares:) name:kShouldQueryMacxSoftwares object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldParseMacxSoftwares:) name:kShouldParseMacxSoftwares object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didParseMacxSoftwares:) name:kDidParseMacxSoftwares object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
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
        // 分类sidebar的items
        NSString *cid = itemAtRow[@"cid"];
        NSArray *categoryArray = [self categoryNameForId:cid];
        if (categoryArray) {
            [self changeToKeyView];
            [[self keyListViewController] filterWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                NSString *value = evaluatedObject[@"type"];
                for (NSString *category in categoryArray) {
                    if ([value isEqualToString:category]) {
                        return YES;
                    }
                }
                return NO;
            }];
        }
    }
}


#pragma mark - ParseResult Delegate
- (void)didBeginParseResult:(PJSoftwareInfoParser*)parser {
    //NSLog(@"Enter %s", __PRETTY_FUNCTION__);
}

- (BOOL)didParseResult:(PJSoftwareInfoParser*)parser withObject:(NSDictionary *)nodeInfo {
    //NSLog(@"Enter %s", __PRETTY_FUNCTION__);
    [_softwares addObject:nodeInfo];
    return NO;
}

- (BOOL)onParseResultError:(PJSoftwareInfoParser*)parser error:(NSError*)error {
    NSLog(@"onParseResultError %@", error);
    [parser.targetObject rearrangeArrayControllerItems];
    PJListViewController *listViewController = parser.targetObject;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidParseMacxSoftwares object:self userInfo:@{@"listViewController": listViewController}];
    return YES;// Do not abort, will use result below
}
- (void)didParseResultDone:(PJSoftwareInfoParser*)parser {
    NSLog(@"Enter %s", __PRETTY_FUNCTION__);
    [parser.targetObject rearrangeArrayControllerItems];
    PJListViewController *listViewController = parser.targetObject;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidParseMacxSoftwares object:self userInfo:@{@"listViewController": listViewController}];
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
