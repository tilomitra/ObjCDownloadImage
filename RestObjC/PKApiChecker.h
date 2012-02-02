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
}

@property (nonatomic, retain) NSString *PARSE_REST_URL;

- (id)init;
- (NSString *)recognizePersonFromParseId:(NSString *)parseId;
@end
