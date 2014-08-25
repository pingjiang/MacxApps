//
//  PJAppDelegate.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJAppDelegate.h"
#import "PJSoftwareInfo.h"
#import "PJSoftwareCollection.h"
#import "PJSoftwareCategory.h"
#import "PJSoftwareGridViewController.h"
#import "PJSoftwareManager.h"

@interface PJAppDelegate ()
@property (strong, nonatomic) NSMutableArray *modelObjects;
@property (strong, nonatomic) NSMutableArray *sourceListItems;

- (void)registerDefaults;

@end


static NSString * const draggingType = @"SourceListExampleDraggingType";


@implementation PJAppDelegate

- (void)registerDefaults {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MacxAppsDefaults" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void)awakeFromNib {
    if (!_softwareGridViewController) {
        _softwareGridViewController = [[PJSoftwareGridViewController alloc] init];
        _defaultView = self.viewBox.contentView;
        
        _keyView = _defaultView;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self registerDefaults];
    
    // Used to support drag and drop in the source list.
    [self.sourceList registerForDraggedTypes:@[draggingType]];
    
    self.sourceListItems = [[NSMutableArray alloc] init];
    [self setUpDataModel];
    
    [self.sourceList reloadData];
    
    //[[PJSoftwareManager sharedManager] querySoftwareListAll];
    // 6103
    [[PJSoftwareManager sharedManager] likeSoftware:6103];
}


#pragma mark - Data Model

/* We could set an identifier on the PXSourceListItem instances, but it makes more sense to put our
 identifying information on the underlying model object in this case.
 
 We also add some dummy Photo objects to each collection to emulate how a real model class would work.
 */
- (void)setUpDataModel
{
    // @[@"最新动态", @"最新软件", @"软件排行", @"装机必备", @"软件更新"
    NSDictionary *names = @{@"PopSoftwares": @"最新动态", @"LatestSoftwares": @"最新软件", @"RankSoftwares": @"软件排行", @"EssentialSoftwares": @"装机必备", @"UpdatedSoftwares": @"软件更新"};
    // Icon images we're going to use in the Source List.
    NSImage *photosImage = [NSImage imageNamed:@"NSUser"];
    [photosImage setTemplate:YES];
    NSImage *eventsImage = [NSImage imageNamed:@"NSUser"];
    [eventsImage setTemplate:YES];
    NSImage *peopleImage = [NSImage imageNamed:@"NSUser"];
    [peopleImage setTemplate:YES];
    NSImage *placesImage = [NSImage imageNamed:@"NSUser"];
    [placesImage setTemplate:YES];
    
    
    self.modelObjects = [NSMutableArray array];
    NSMutableArray *sourceListSysItems = [NSMutableArray array];
    
    for (NSString *key in names) {
        PJSoftwareCollection *softaresCollection = [PJSoftwareCollection collectionWithTitle:names[key] identifier:key type:PJSoftwareCollectionTypeLibrary];
        [self addNumberOfPhotoObjects:264 toCollection:softaresCollection];
        // Store all of the model objects in an array because each source list item only holds a weak reference to them.
        [self.modelObjects addObject:softaresCollection];
        
        [sourceListSysItems addObject:[PXSourceListItem itemWithRepresentedObject:softaresCollection icon:photosImage]];
    }
    
    
    
    // Set up our Source List data model used in the Source List data source methods.
    PXSourceListItem *libraryItem = [PXSourceListItem itemWithTitle:@"苹果软件" identifier:nil];
    libraryItem.children = sourceListSysItems;
    [self.sourceListItems addObject:libraryItem];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mac-soft-categories-macx" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"Reading JSON file error: %@", error);
        return;
    }
    NSArray *jsonItems = jsonObj[@"items"];
    
    NSImage *albumImage = [NSImage imageNamed:@"NSUser"];
    [albumImage setTemplate:YES];
    
    PXSourceListItem *albumsItem = [PXSourceListItem itemWithTitle:jsonObj[@"name"] identifier:nil];
    // albumsItem.children = sourceListUserItems;
    [self.sourceListItems addObject:albumsItem];
    
    for (NSDictionary *treeNode in jsonItems) {
        NSString *subItemName = [treeNode[@"name"] copy];
        NSInteger subItemRawId = [treeNode[@"cid"] integerValue];
        NSString *subItemId = subItemRawId == 0 ? nil : [NSString stringWithFormat:@"MacxAppsCategory%ld", subItemRawId];
        
        NSMutableArray *sourceListUserItems = [NSMutableArray array];
        PXSourceListItem *appCategoryItem = [PXSourceListItem itemWithTitle:subItemName identifier:subItemId];
        appCategoryItem.children = sourceListUserItems;
        
        NSArray *subsubItems = treeNode[@"items"];
        for (NSDictionary *dict in subsubItems) {
            NSString *subsubItemName = [dict[@"name"] copy];
            NSInteger subsubItemRawId = [dict[@"cid"] integerValue];
            NSString *subsubItemId = subsubItemRawId == 0 ? nil : [NSString stringWithFormat:@"MacxAppsSubCategory%ld", subsubItemRawId];
            PJSoftwareCollection *softaresCollection = [PJSoftwareCollection collectionWithTitle:subsubItemName identifier:subsubItemId type:PJSoftwareCollectionTypeUserCreated];
            [self addNumberOfPhotoObjects:123 toCollection:softaresCollection];
            // Store all of the model objects in an array because each source list item only holds a weak reference to them.
            [self.modelObjects addObject:softaresCollection];
            
            [sourceListUserItems addObject:[PXSourceListItem itemWithRepresentedObject:softaresCollection icon:albumImage]];
            
            // [self buildSourceList:level + 1 withNode:dict onCollectionCreated:onCollectionCreated];
            
            appCategoryItem.children = sourceListUserItems;
        }
        
        [albumsItem addChildItem:appCategoryItem];
    }
    
    
}

/* Convenience method for adding dummy Photo objects to a PJSoftwareCollection instance. */
- (void)addNumberOfPhotoObjects:(NSUInteger)numberOfObjects toCollection:(PJSoftwareCollection *)collection
{
    NSMutableArray *softwares = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberOfObjects; ++i)
        [softwares addObject:[[PJSoftwareInfo alloc] init]];
    collection.softwares = softwares;
}

// Methods to avoid hardcoding subscripts into multiple places in the code.
- (PXSourceListItem *)libraryItem
{
    return self.sourceListItems[0];
}

- (PXSourceListItem *)albumsItem
{
    return self.sourceListItems[1];
}

#pragma mark - Actions

- (IBAction)addButtonAction:(id)sender
{
    NSImage *albumImage = [NSImage imageNamed:@"album"];
    [albumImage setTemplate:YES];
    
    PJSoftwareCollection *collection = [PJSoftwareCollection collectionWithTitle:@"New Album" identifier:nil type:PJSoftwareCollectionTypeUserCreated];
    [self.modelObjects addObject:collection];
    
    PXSourceListItem *newItem = [PXSourceListItem itemWithRepresentedObject:collection icon:albumImage];
    [self.albumsItem addChildItem:newItem];
    
    NSUInteger childIndex = [[self.albumsItem children] indexOfObject:newItem];
    [self.sourceList insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:childIndex]
                                 inParent:self.albumsItem
                            withAnimation:NSTableViewAnimationEffectNone];
    
    [self.sourceList editColumn:0 row:[self.sourceList rowForItem:newItem] withEvent:nil select:YES];
}

- (IBAction)removeButtonAction:(id)sender
{
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    PXSourceListItem *parentItem = self.albumsItem;
    
    [self.sourceList removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:[parentItem.children indexOfObject:selectedItem]]
                                 inParent:parentItem
                            withAnimation:NSTableViewAnimationSlideUp];
    
    [self.modelObjects removeObject:selectedItem.representedObject];
    
    // Only 'album' items can be deleted.
    [parentItem removeChildItem:selectedItem];
}

#pragma mark - PXSourceList Data Source

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
    if (!item)
        return self.sourceListItems.count;
    
    return [[item children] count];
}

- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
    if (!item)
        return self.sourceListItems[index];
    
    return [[item children] objectAtIndex:index];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item
{
    return [item hasChildren];
}

#pragma mark - PXSourceList Delegate

- (BOOL)sourceList:(PXSourceList *)aSourceList isGroupAlwaysExpanded:(id)group
{
    return YES;
}

- (NSView *)sourceList:(PXSourceList *)aSourceList viewForItem:(id)item
{
    PXSourceListTableCellView *cellView = nil;
    if ([aSourceList levelForItem:item] == 0)
        cellView = [aSourceList makeViewWithIdentifier:@"HeaderCell" owner:nil];
    else
        cellView = [aSourceList makeViewWithIdentifier:@"MainCell" owner:nil];
    
    PXSourceListItem *sourceListItem = item;
    PJSoftwareCollection *collection = sourceListItem.representedObject;
    
    // Only allow us to edit the user created photo collection titles.
    BOOL isTitleEditable = [collection isKindOfClass:[PJSoftwareCollection class]] && collection.type == PJSoftwareCollectionTypeUserCreated;
    cellView.textField.editable = isTitleEditable;
    cellView.textField.selectable = isTitleEditable;
    
    cellView.textField.stringValue = sourceListItem.title ? sourceListItem.title : [sourceListItem.representedObject title];
    cellView.imageView.image = [item icon];
    cellView.badgeView.hidden = collection.softwares.count == 0;
    cellView.badgeView.badgeValue = collection.softwares.count;
    
    return cellView;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
    PXSourceListItem *selectedItem = [self.sourceList itemAtRow:self.sourceList.selectedRow];
    BOOL removeButtonEnabled = NO;
    NSString *newLabel = @"";
    if (selectedItem) {
        // Only allow us to remove items in the 'albums' group.
        removeButtonEnabled = [[self.albumsItem children] containsObject:selectedItem];
        
        // We can use the underlying model object to do something based on the selection.
        PJSoftwareCollection *collection = selectedItem.representedObject;
        
        if (collection.identifier)
            newLabel = [NSString stringWithFormat:@"'%@' collection selected.", collection.identifier];
        else
            newLabel = @"User-created collection selected.";
    }
    
    self.selectedItemLabel.stringValue = newLabel;
    self.removeButton.enabled = removeButtonEnabled;
    
    // Change view content
    // _softwareGridViewController
    if (_keyView != [_softwareGridViewController view]) {
        _keyView = [_softwareGridViewController view];
        [self.viewBox setContentView:_keyView];
        [_softwareGridViewController loadData];
    }
}

#pragma mark - Drag and Drop

- (BOOL)sourceList:(PXSourceList*)aSourceList writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard
{
    // Only allow user-created items (not those in "Library" to be moved around).
    for (PXSourceListItem *item in items) {
        PJSoftwareCollection *collection = item.representedObject;
        if (![collection isKindOfClass:[PJSoftwareCollection class]] || collection.type != PJSoftwareCollectionTypeUserCreated)
            return NO;
    }
    
    // We're dragging from and to the 'Albums' group.
    PXSourceListItem *parentItem = self.albumsItem;
    
    // For simplicity in this example, put the dragged indexes on the pasteboard. Since we use the representedObject
    // on SourceListItem, we cannot reliably archive it directly.
    NSMutableIndexSet *draggedChildIndexes = [NSMutableIndexSet indexSet];
    for (PXSourceListItem *item in items)
        [draggedChildIndexes addIndex:[[parentItem children] indexOfObject:item]];
    
    [pboard declareTypes:@[draggingType] owner:self];
    [pboard setData:[NSKeyedArchiver archivedDataWithRootObject:draggedChildIndexes] forType:draggingType];
    
    return YES;
}

- (NSDragOperation)sourceList:(PXSourceList*)sourceList validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    PXSourceListItem *albumsItem = self.albumsItem;
    
    // Only allow the items in the 'albums' group to be moved around. It can either be dropped on the group header, or inserted between other child items.
    // It can't be made the child of another item in this group, so the only valid case is when the proposedItem is the 'Albums' group item.
    if (![item isEqual:albumsItem])
        return NSDragOperationNone;
    
    return NSDragOperationMove;
}

- (BOOL)sourceList:(PXSourceList*)aSourceList acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard *draggingPasteboard = info.draggingPasteboard;
    NSMutableIndexSet *draggedChildIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:[draggingPasteboard dataForType:draggingType]];
    
    PXSourceListItem *parentItem = self.albumsItem;
    NSMutableArray *draggedItems = [NSMutableArray array];
    [draggedChildIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [draggedItems addObject:[[parentItem children] objectAtIndex:idx]];
    }];
    
    // An index of -1 means it's been dropped on the group header itself, so insert at the end of the group.
    if (index == -1)
        index = parentItem.children.count;
    
    // Perform the Source List and model updates.
    [aSourceList beginUpdates];
    [aSourceList removeItemsAtIndexes:draggedChildIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [parentItem removeChildItems:draggedItems];
    
    // We have to calculate the new child index which we have to perform the drop at, since we've just removed items from the parent item which
    // may have come before the drop index.
    NSUInteger adjustedDropIndex = index - [draggedChildIndexes countOfIndexesInRange:NSMakeRange(0, index)];
    
    // The insertion indexes are now simply from the adjusted drop index.
    NSIndexSet *insertionIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(adjustedDropIndex, draggedChildIndexes.count)];
    [parentItem insertChildItems:draggedItems atIndexes:insertionIndexes];
    
    [aSourceList insertItemsAtIndexes:insertionIndexes
                             inParent:parentItem
                        withAnimation:NSTableViewAnimationEffectNone];
    [aSourceList endUpdates];
    
    return YES;
}

@end
