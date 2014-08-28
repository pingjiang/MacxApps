//
//  NSString+PJAdditions.h
//  MacxApps
//
//  Created by 平江 on 14-8-27.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PJAdditions)

- (NSString*)substringWithBound:(NSString*)lbound withBound:(NSString*)rbound options:(NSStringCompareOptions)mask;

@end
