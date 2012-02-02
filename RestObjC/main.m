//
//  main.m
//  RestObjC
//
//  Created by Tilo Mitra on 12-01-28.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "PKApiChecker.h"

int main (int argc, const char * argv[])
{

    @autoreleasepool {
            
        // insert code here...
        NSLog(@"Starting Engines...");
        //NSURL *url = [NSURL URLWithString:@"http://stormy-moon-8803.herokuapp.com/api/getUnrecognizedImages"];

        PKApiChecker *checker = [[PKApiChecker alloc] init];
        
        NSDate *d = [NSDate dateWithTimeIntervalSinceNow: 2.0];
        
        
        NSTimer *t = [[NSTimer alloc] initWithFireDate: d
                                              interval: 5.0
                                                target: checker
                                              selector:@selector(retrieveUnrecognizedParseIdFromUrl:)
                                              userInfo:nil repeats:YES];
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:t forMode: NSDefaultRunLoopMode];
        [runner run];
        
    }
    return 0;
}
