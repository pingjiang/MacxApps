//
//  PJSoftwareCollection.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareInfo.h"
#import "PJSoftwareCollection.h"

@implementation PJSoftwareCollection

+ (id)collectionWithTitle:(NSString *)title identifier:(NSString *)identifier type:(PJSoftwareCollectionType)type
{
    PJSoftwareCollection *collection = [[PJSoftwareCollection alloc] init];
    
    collection.title = title;
    collection.identifier = identifier;
    collection.type = type;
    
    return collection;
}


@end
