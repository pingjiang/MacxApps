//
//  NSData+PJAdditions.h
//  MacxApps
//
//  Created by 平江 on 14-8-31.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (PJAdditions)

- (NSData *)cleanUTF8;
- (NSData*)convertToUTF8:(CFStringEncodings)encoding;
- (NSData*)convertBIG52UTF8;
- (NSData*)convertGBK2UTF8;


@end
