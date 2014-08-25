//
//  PJSoftwareCollection.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, PJSoftwareCollectionType) {
    PJSoftwareCollectionTypeLibrary,
    PJSoftwareCollectionTypeUserCreated
};

@interface PJSoftwareCollection : NSObject


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSArray *softwares;
@property (assign, nonatomic) PJSoftwareCollectionType type;

+ (id)collectionWithTitle:(NSString *)title identifier:(NSString *)identifier type:(PJSoftwareCollectionType)type;



@end
