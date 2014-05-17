//
//  PBTacheMonteurChantier.m
//  GraniouProject
//
//  Created by Philippe Tumata on 16/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBTacheMonteurChantier.h"

#define keyIDChantier       @"idChantier"
#define keyIDTache          @"idTacheChantier"

#define keyTitre            @"titreChantier"
#define keyDescription      @"descriptionTacheChantier"

#define keyCommentaire      @"commentaireTacheChantier"
#define keyCommentaireImage @"commentaireTacheChantierImage"

@interface PBTacheMonteurChantier ()

@property (readwrite) NSString          *titre;
@property (readwrite) NSString          *description;

@end

@implementation PBTacheMonteurChantier

// Constructeur
-(id)initWithIdChantier:(NSString *)idChantier idTache:(NSString *)idTache name:(NSString *)name description:(NSString *)descr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm
{
    
    self = [super init];
    if (self) {
        _idChantier = idChantier;
        _idTache = idTache;
        
        _titre = name;
        _description = descr;
        
        _commentaire = comm;
        _imageCommentaire = imgComm;
        
    }
    return self;
}

-(id)initTacheWithInfos:(NSDictionary *)tacheInfos {
    self = [super init];
    if (self) {
        _idChantier = [tacheInfos objectForKey:keyIDChantier];
        _idTache = [tacheInfos objectForKey:keyIDTache];
        
        _titre = [tacheInfos objectForKey:keyTitre];
        _description = [tacheInfos objectForKey:keyDescription];
        
        _commentaire = [tacheInfos objectForKey:keyCommentaire];
        _imageCommentaire = [tacheInfos objectForKey:keyCommentaireImage];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:_idChantier forKey:keyIDChantier];
	[encoder encodeObject:_idTache forKey:keyIDTache];
	
    [encoder encodeObject:_titre forKey:keyTitre];
    [encoder encodeObject:_description forKey:keyDescription];
    
    [encoder encodeObject:_commentaire forKey:keyCommentaire];
    [encoder encodeObject:_imageCommentaire forKey:keyCommentaireImage];
}
- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if( self != nil )
	{
        //decode properties, other class vars
		_idChantier = [decoder decodeObjectForKey:keyIDChantier];
        _idTache = [decoder decodeObjectForKey:keyIDTache];
        
        _titre = [decoder decodeObjectForKey:keyTitre];
        _description = [decoder decodeObjectForKey:keyDescription];
        
        _commentaire = [decoder decodeObjectForKey:keyCommentaire];
        _imageCommentaire = [decoder decodeObjectForKey:keyCommentaireImage];
	}
	return self;
}



@end
