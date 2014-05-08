//
//  Tache.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "Tache.h"


@interface Tache ()

@property (readwrite) NSString          *titre;
@property (readwrite) NSString          *description;
@property (readwrite) UIImage           *imageDescription;

@end

@implementation Tache

// Constructeur
-(id)initWithIdChantier:(NSInteger)idChantier idTache:(NSInteger)idTache name:(NSString *)name description:(NSString *)descr imageDescription:(UIImage *)imgDescr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm
{
    
    self = [super init];
    if (self) {
        _idChantier = idChantier;
        _idTache = idTache;
        
        _titre = name;
        _description = descr;
        _imageDescription = imgDescr;
        
        _commentaire = comm;
        _imageCommentaire = imgComm;
        
    }
    return self;
}

@end
