//
//  Tache.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBTacheMonteurLeveeReserve : NSObject <NSCoding>

@property (readonly, nonatomic) NSString            *idChantier;
@property (readonly, nonatomic) NSString            *idTache;

@property (readonly, copy, nonatomic) NSString      *titre;
@property (readonly, copy, nonatomic) NSString      *description;
@property (readonly, copy, nonatomic) UIImage       *imageDescription;

@property (copy, nonatomic) NSString                *commentaire;
@property (copy, nonatomic) UIImage                 *imageCommentaire;


- (id)initTacheWithInfos:(NSDictionary *)tacheInfos;

- (NSData *)tacheToData;

@end
