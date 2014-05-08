//
//  PBChantier.m
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBChantier.h"





@implementation PBChantier{
    NSMutableArray *_tachesArray;
}

static PBChantier *_sharedClass;



- (NSArray *)taches
{
    return [_tachesArray copy];
}







@end
