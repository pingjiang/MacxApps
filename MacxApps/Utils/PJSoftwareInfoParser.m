//
//  PJSoftwareInfoParser.m
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import "PJSoftwareInfoParser.h"


@interface PJSoftwareInfoParser ()

- (BOOL)isNodeElement:(NSString*)name;
- (BOOL)isNodeMemberElement:(NSString*)name;
- (NSString *)trim:(NSString*)str;

@end

@implementation PJSoftwareInfoParser

@synthesize needDebug;
@synthesize nodeList = _nodeList;

- (id<PJParseResultDelegate>)resultDelegate {
    return _resultDelegate;
}
- (void)setResultDelegate:(id<PJParseResultDelegate>)theDelegate {
    _resultDelegate = theDelegate;
}

- (BOOL)isNodeElement:(NSString *)name {
    return [@"software" isEqualToString:name];
}

- (BOOL)isNodeMemberElement:(NSString *)name {
    NSArray *members = @[@"id", @"type", @"name", @"bundle_id", @"language", @"os", @"osbit", @"keywords", @"introduction", @"description", @"official_site", @"release_time", @"free", @"plug", @"star", @"sandbox", @"logo_url", @"pic_url", @"lastmod", @"version", @"build_version", @"download_url", @"download_url2", @"baidu_key", @"macappstore", @"other_download_url", @"official_download_url", @"size", @"md5", @"sha1", @"score", @"source_detail"];
    for (NSString *member in members) {
        if ([member isEqualToString:name]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"]];
}

- (id)initWithData:(NSData *)data {
    if (self = [super initWithData:data]) {
        _tagStack = [[NSMutableArray alloc] init];
        _nodeList = [[NSMutableArray alloc] init];
        _nodeInfo = [[NSMutableDictionary alloc] init];
        _tmpArray = [[NSMutableArray alloc] init];
        _buffer = [[NSMutableString alloc] init];
        [self setDelegate:self];
        [self setNeedDebug:NO];
    }
    
    return self;
}

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if (needDebug) NSLog(@"parserDidStartDocument");
    [_resultDelegate didBeginParseResult];
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (needDebug) NSLog(@"parserDidEndDocument");
    [_resultDelegate didParseResultDone];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (needDebug) NSLog(@"didStartElement %@", elementName);
    [_tagStack addObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (needDebug) NSLog(@"didEndElement %@", elementName);
    NSString *lastElementName = [_tagStack lastObject];
    if ([elementName isEqualToString:lastElementName]) {
        [_tagStack removeLastObject];
    }
    
    lastElementName = [_tagStack lastObject];
    if ([@"url" isEqualToString:elementName] && [@"other_download_url" isEqualToString:lastElementName]) {
        NSString *elementValue = [self trim:_buffer];
        if (needDebug) NSLog(@"store %@ = %@", elementName, elementValue);
        if ([elementValue length] > 0) {
            [_tmpArray addObject:elementValue];
        }
        [_buffer deleteCharactersInRange:NSMakeRange(0, [_buffer length])];
    }
    
    if ([self isNodeElement:elementName]) {
        [_resultDelegate didParseResult:[_nodeInfo copy]];
        if (needDebug) NSLog(@"result %@", _nodeInfo);
        [_nodeInfo removeAllObjects];
    } else if ([self isNodeMemberElement:elementName]) {
        if ([@"other_download_url" isEqualToString:elementName]) {
            [_nodeInfo setObject:[_tmpArray copy] forKey:elementName];
            [_tmpArray removeAllObjects];
        } else {
            NSString *elementValue = [self trim:_buffer];
            if (needDebug) NSLog(@"store %@ = %@", elementName, elementValue);
            [_nodeInfo setObject:elementValue forKey:elementName];
            [_buffer deleteCharactersInRange:NSMakeRange(0, [_buffer length])];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (needDebug) NSLog(@"foundCharacters %@", string);
    // if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \r\n"]] length] > 0)
    [_buffer appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString {
    if (needDebug) NSLog(@"foundIgnorableWhitespace %@", whitespaceString);
    //[_buffer appendString:whitespaceString];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if (needDebug) NSLog(@"foundCDATA %@", CDATABlock);
    NSString *utf8String = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [_buffer appendString:utf8String];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (needDebug) NSLog(@"parseErrorOccurred %@", parseError);
    [_resultDelegate onParseResultError:parseError];
}
// ...and this reports a fatal error to the delegate. The parser will stop parsing.

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    if (needDebug) NSLog(@"validationErrorOccurred %@", validationError);
    [_resultDelegate onParseResultError:validationError];
}

@end

