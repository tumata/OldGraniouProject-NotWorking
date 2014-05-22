//
//  PBNetworking.m
//  GraniouProject
//
//  Created by Philippe Tumata on 14/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBNetworking.h"

@implementation PBNetworking

+ (void)sendHttpPostWithData:(NSString *)dataToPost
             toURLWithString:(NSString *)stringURL
                    delegate:(id<NSURLSessionDataDelegate>)delegate {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: delegate delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[dataToPost dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
    
}

+ (void)sendHttpPostTacheWithData:(NSData *)body
                  toUrlWithString:(NSString *)stringURL
                         delegate:(id<NSURLSessionDataDelegate>)delegate {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: delegate delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURL * url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // Body donnee en parametres
    [request setHTTPBody:body];
    
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:request];
    [dataTask resume];


}


@end
