//
//  PBNetworkingSendTaches.h
//  GraniouProject
//
//  Created by Philippe Tumata on 26/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBNetworkingSendTaches : NSObject <NSURLSessionDataDelegate>

+ (void)sendAllTachesFromChantierToUrl;

@end
