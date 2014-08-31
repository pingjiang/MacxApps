//
//  NSData+PJAdditions.m
//  MacxApps
//
//  Created by 平江 on 14-8-31.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "NSData+PJAdditions.h"
#import <iconv.h>

@implementation NSData (PJAdditions)

- (NSData *)cleanUTF8 {
    // Make sure its utf-8
    iconv_t ic= iconv_open("UTF-8", "UTF-8//IGNORE");
    // Remove invaild characters
    int one = 1;
    iconvctl(ic, ICONV_SET_DISCARD_ILSEQ, &one);
    
    size_t inBytes, outBytes;
    inBytes = outBytes = self.length;
    char *inbuf  = (char*)self.bytes;
    char *outbuf = (char*) malloc(sizeof(char) * self.length);
    char *outptr = outbuf;
    
    if (iconv(ic, &inbuf, &inBytes, &outptr, &outBytes) == (size_t) - 1) {
        NSLog(@"iconv failed");
        return self;
    }
    
    NSData *result = [NSData dataWithBytes:outbuf length:self.length - outBytes];
    iconv_close(ic);
    free(outbuf);
    
    NSLog(@"iconv success %ld - %ld = %ld", [self length], [result length], [self length] - [result length]);
    return result;
}

- (NSData*)convertToUTF8:(CFStringEncodings)encoding {
    NSURL *writeURL = [NSURL fileURLWithPath:@"macx-softwares.xml"];
    NSError *error = nil;
    [self writeToURL:writeURL options:0 error:&error];
    if (error) {
        NSLog(@"Write to %@ error: %@", writeURL, error);
    }
    NSStringEncoding nsStringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
    NSString* content = [[NSString alloc] initWithData:self encoding:nsStringEncoding];
    if (!content) {
        return self;
    }
    NSData *xmlData = [content dataUsingEncoding:NSUTF8StringEncoding];
    return xmlData;
}

- (NSData *)convertBIG52UTF8 {
    return [self convertToUTF8:kCFStringEncodingBig5];
}

- (NSData *)convertGBK2UTF8 {
    return [self convertToUTF8:kCFStringEncodingGBK_95];
}

@end
