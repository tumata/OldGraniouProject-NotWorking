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

+ (PBChantier *)sharedChantier;

- (NSArray *)taches;


//Appeler toutes les fonction vers le modele depuis ici.


/*
- (void)bookmarkMaster:(PBTache *)master;
- (void)unbookmarkMaster:(PBTache *)master;

*/


@end
