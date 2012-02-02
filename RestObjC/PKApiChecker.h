//
//  PKApiChecker.h
//  RestObjC
//
//  Created by Tilo Mitra on 12-02-01.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
@interface PKApiChecker : NSObject {
    NSString *PARSE_REST_URL;
    NSURL *DB_REQUEST_URL;
}

@property (nonatomic, retain) NSString *PARSE_REST_URL;
@property (nonatomic, retain) NSURL *DB_REQUEST_URL;

- (id)init;
- (void)startLoop:(NSTimer *)timer;
- (void)retrieveUnrecognizedParseIdFromUrl:(NSTimer *)timer;
- (NSString *)recognizePersonFromParseId:(NSString *)parseId;
@end
