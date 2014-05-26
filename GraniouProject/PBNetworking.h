//
//  PBNetworking.h
//  GraniouProject
//
//  Created by Philippe Tumata on 14/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBNetworking : NSObject

+ (void)sendHttpPostWithData:(NSString *)dataToPost
             toURLWithString:(NSString *)stringURL
                    delegate:(id<NSURLSessionDataDelegate>)delegate;

+ (void)sendHttpPostTacheWithData:(NSData *)body
                  toUrlWithString:(NSString *)stringURL
                         delegate:(id<NSURLSessionDataDelegate>)delegate;


@end
