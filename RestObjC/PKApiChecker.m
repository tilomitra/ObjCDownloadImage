//
//  PKApiChecker.m
//  RestObjC
//
//  Created by Tilo Mitra on 12-02-01.
//  Copyright (c) 2012 University of Waterloo. All rights reserved.
//

#import "PKApiChecker.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

static NSString *PARSE_APPLICATION_ID   =     @"DOCKNIyEg5jGqZFj18sBxJOTXvYCQjryFDCrD35G";
static NSString *PARSE_MASTER_KEY       =     @"UDyagsksRQgwPf9ZF5Yj43vhvvo7ccAVzSenrIRB";

@implementation PKApiChecker
@synthesize PARSE_REST_URL;
@synthesize DB_REQUEST_URL;

- (id)init {
    
    self = [super init];
    if (self) {
        [self setPARSE_REST_URL:[NSString stringWithFormat:@"https://%@:%@%@", PARSE_APPLICATION_ID, PARSE_MASTER_KEY, @"@api.parse.com/1/classes/CapturedPhoto/"]];
        [self setDB_REQUEST_URL:[NSURL URLWithString:@"http://stormy-moon-8803.herokuapp.com/api/getUnrecognizedImages"]];

    }
    return self;
}

- (void)retrieveUnrecognizedParseIdFromUrl:(NSTimer *)timer {
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[self DB_REQUEST_URL]];
    NSLog(@"Sending Request to Parse...");
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
            NSLog(@"Parse ID Acquired with ID of %@...", parseId);
            NSString *resultString = [self recognizePersonFromParseId:parseId];
            [self saveImageAsRecognizedWithParseId:parseId andFacebookId:@"sampleFbId" andRecognizedAs:@"sampleRecognizedAs"];
        }
        
    }
}

- (NSString *)recognizePersonFromParseId:(NSString *)parseId {
    //Get Data from Parse for each Parse ID
    
    NSURL *parseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", [self PARSE_REST_URL], parseId]];
    
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
        
        NSTask *task;
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
        
        //NSLog (@"returning the following string %@", string);

        return string;
    }
    
    return @"";
}


- (void)saveImageAsRecognizedWithParseId:(NSString *)parseId andFacebookId:(NSString *)fbId andRecognizedAs:(NSString *)name {
    
    
    NSString *apiUrlString = [NSString stringWithFormat:@"http://stormy-moon-8803.herokuapp.com/api/updateUnrecognizedImage/%@/%@/%@", parseId, fbId, name];
    
    NSLog(@"Updating unrecognized image as a recognized image. API URL called is %@ ", apiUrlString);

    
    NSURL *apiUrl = [NSURL URLWithString:apiUrlString];
    ASIHTTPRequest *apiRequest = [ASIHTTPRequest requestWithURL:apiUrl];
    [apiRequest startSynchronous];
    
    NSError *error = [apiRequest error];
    if (!error) {
        NSString *response = [apiRequest responseString];
        NSLog(@"Success in updating. Request response was - - - %@", response);       
    }
    
}
@end
