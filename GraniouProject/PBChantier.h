//
//  PBChantier.h
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTache.h"

@interface PBChantier : NSObject

@property (nonatomic) NSInteger                 *_idChantier;
@property (nonatomic, strong) NSMutableArray    *_tachesArray;


+ (PBChantier *)sharedChantier;


@end
