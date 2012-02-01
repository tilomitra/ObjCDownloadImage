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

int main (int argc, const char * argv[])
{

    @autoreleasepool {
            
        // insert code here...
        NSLog(@"Starting Engines...");
        
        NSString *PARSE_APPLICATION_ID   =     @"DOCKNIyEg5jGqZFj18sBxJOTXvYCQjryFDCrD35G";
        NSString *PARSE_MASTER_KEY       =     @"UDyagsksRQgwPf9ZF5Yj43vhvvo7ccAVzSenrIRB";
        
        NSString *PARSE_REST_URL = [NSString stringWithFormat:@"https://%@:%@%@", PARSE_APPLICATION_ID, PARSE_MASTER_KEY, @"@api.parse.com/1/classes/CapturedPhoto/"];
        
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:3000/api/getUnrecognizedImages"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            
            
            //get the JSON and store it in a NSDictionary
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary *responseObj = [parser objectWithString:response error:nil];
            
            
            //Loop over parse_id's in the dictionary and query Parse API for image
            for (NSDictionary *parseIdObj in responseObj)
            {
                
                
                //Get Data from Parse for each Parse ID
                NSString *parseId = [parseIdObj objectForKey:@"parse_id"];
                
                NSURL *parseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", PARSE_REST_URL, parseId]];

                ASIHTTPRequest *parseRequest = [ASIHTTPRequest requestWithURL:parseUrl];
                [parseRequest startSynchronous];
                
                NSError *parseErr = [parseRequest error];
                if (!parseErr) {
                    NSString *parseResponse = [parseRequest responseString];
                    SBJsonParser *parseJSONParser = [[SBJsonParser alloc] init];
                    NSDictionary *parseResponseObj = [parseJSONParser objectWithString:parseResponse error:nil];
                    NSString *pictureUrlString = [[parseResponseObj objectForKey:@"imageFile"] objectForKey:@"url"];
                    NSURL *pictureUrl = [NSURL URLWithString:pictureUrlString];
                    NSLog(@"Downloading image for string - - - %@", pictureUrlString);
                    
                    
                    ASIHTTPRequest *parseImageRequest = [ASIHTTPRequest requestWithURL:pictureUrl];
                    [parseImageRequest setDownloadDestinationPath:@"/Users/Tilo/Desktop/SAMPLE.jpg"];
                    [parseImageRequest startSynchronous];
                    
                    NSLog(@"Image completed downloading");
                }
                
                
                
                /*NSTask *task;
                task = [[NSTask alloc] init];
                [task setLaunchPath: @"~/DesignProj/iosApp/RestWrap/RestExample/RestExample/testRest"];
                
                NSArray *arguments;
                arguments = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@/foo/bar.jpg", parseId], nil];
                [task setArguments: arguments];
                
                NSPipe *pipe;
                pipe = [NSPipe pipe];
                [task setStandardOutput: pipe];
                
                NSFileHandle *file;
                file = [pipe fileHandleForReading];
                
                [task launch];
                
                NSData *data;
                data = [file readDataToEndOfFile];
                
                NSString *string;
                string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                NSLog (@"%@ = %@", parseId, string);
                */
                
            }

        }
        
    }
    return 0;
}
