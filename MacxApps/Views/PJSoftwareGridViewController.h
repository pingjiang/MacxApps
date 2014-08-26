//
//  PJSoftwareGridViewController.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PJSoftwareGridViewController : NSViewController<NSCollectionViewDelegate> {
    NSMutableDictionary *_sortDescriptors;
}

@property (strong) IBOutlet NSArrayController *arrayController;

@property (weak) IBOutlet NSCollectionView *gridView;

@property (strong) NSArray *items;

// Bind actions
- (IBAction)downloadButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo;
- (IBAction)detailButtonAction:(id)sender withSoftwareInfo:(id)softwareInfo ;

// sort
- (void)sortBy:(NSString*)key;


@end


@interface PJTimestampValueTransformer : NSValueTransformer

@end

