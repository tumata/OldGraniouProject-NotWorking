//
//  Tache.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBTache : NSObject

@property (readonly, nonatomic) NSInteger           idChantier;
@property (readonly, nonatomic) NSInteger           idTache;

@property (readonly, copy, nonatomic) NSString      *titre;
@property (readonly, copy, nonatomic) NSString      *description;
@property (readonly, copy, nonatomic) UIImage     *imageDescription;

@property (copy, nonatomic) NSString      *commentaire;
@property (copy, nonatomic) UIImage     *imageCommentaire;


-(id)initWithIdChantier:(NSInteger)idChantier idTache:(NSInteger)idTache name:(NSString *) name description:(NSString *)descr imageDescription:(UIImage *)imgDescr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm;

@end
