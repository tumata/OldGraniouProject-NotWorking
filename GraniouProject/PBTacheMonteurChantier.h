//
//  PBTacheMonteurChantier.h
//  GraniouProject
//
//  Created by Philippe Tumata on 16/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBTacheMonteurChantier : NSObject <NSCoding>

@property (readonly, nonatomic) NSString            *idChantier;
@property (readonly, nonatomic) NSString            *idTache;

@property (readonly, copy, nonatomic) NSString  *titre;
@property (readonly, copy, nonatomic) NSString  *description;

@property (copy, nonatomic) NSString    *commentaire;
@property (copy, nonatomic) UIImage     *imageCommentaire;


-(id)initWithIdChantier:(NSString *)idChantier idTache:(NSString *)idTache name:(NSString *) name description:(NSString *)descr  commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm;



@end
