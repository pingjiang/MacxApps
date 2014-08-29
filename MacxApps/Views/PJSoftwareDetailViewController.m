//
//  PJSoftwareDetailViewController.m
//  MacxApps
//
//  Created by 平江 on 14-8-26.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareDetailViewController.h"

@interface PJSoftwareDetailViewController ()

@end

@implementation PJSoftwareDetailViewController


- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (IBAction)openLinkAction:(id)sender {
    NSString *identifier = [sender identifier];
    if (!identifier) {
        return;
    }
    
    id obj = [self.representedObject objectForKey:identifier];
    if (!obj) {
        return;
    }
    
    NSString *foundUrl = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        foundUrl = obj;
    } else if ([obj isKindOfClass:[NSArray class]]) {
        for (NSString *url in obj) {
            if ([url length] == 0) {
                continue;
            }
            
            foundUrl = url;
            break;
        }
    }
    
    NSLog(@"Open URL %@ for %@", foundUrl, identifier);
    if (foundUrl && [foundUrl length] > 0) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:foundUrl]];
    }
}
@end
