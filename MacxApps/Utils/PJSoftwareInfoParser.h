//
//  PJSoftwareInfoParser.h
//  MacxApps
//
//  Created by 平江 on 14-8-25.
//  Copyright (c) 2014年 平江. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PJParseResultDelegate <NSObject>

- (void)didBeginParseResult;
- (void)didParseResult:(NSDictionary *)nodeInfo;
- (void)onParseResultError:(NSError*)error;
- (void)didParseResultDone;

@end

@interface PJSoftwareInfoParser : NSXMLParser<NSXMLParserDelegate> {
    id _resultDelegate;
    NSXMLParser *_parser;
    NSMutableArray *_tagStack;
    NSMutableDictionary *_nodeInfo;
    NSMutableArray *_tmpArray;
    NSMutableString *_buffer;
}

@property (nonatomic) BOOL needDebug;
@property (nonatomic, strong) NSMutableArray *nodeList;

- (id<PJParseResultDelegate>)resultDelegate;
- (void)setResultDelegate:(id<PJParseResultDelegate>)theDelegate;

@end


