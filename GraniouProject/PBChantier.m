//
//  PBChantier.m
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBChantier.h"



@implementation PBChantier

static PBChantier *_sharedInstance;

+ (void)initialize {
    if (self == [PBChantier class]) {
        _sharedInstance = [[super alloc] init];
    }
}


+ (PBChantier *)sharedChantier {
    return _sharedInstance;
}


@end