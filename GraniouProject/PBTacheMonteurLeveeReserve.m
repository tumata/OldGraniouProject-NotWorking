//
//  Tache.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBTacheMonteurLeveeReserve.h"

#define keyIDChantier       @"idChantier"
#define keyIDTache          @"idTacheChantier"

#define keyTitre            @"titreChantier"
#define keyDescription      @"descriptionTacheChantier"
#define keyDescriptionImage @"descriptionTacheChantierImage"

#define keyCommentaire      @"commentaireTacheChantier"
#define keyCommentaireImage @"commentaireTacheChantierImage"

@interface PBTacheMonteurLeveeReserve ()

@property (readwrite) NSString          *titre;
@property (readwrite) NSString          *description;
@property (readwrite) UIImage           *imageDescription;

@end

@implementation PBTacheMonteurLeveeReserve

// Constructeur
-(id)initWithIdChantier:(NSString *)idChantier idTache:(NSString *)idTache name:(NSString *)name description:(NSString *)descr imageDescription:(UIImage *)imgDescr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm
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


#pragma mark - NSEncoder

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:_idChantier forKey:keyIDChantier];
	[encoder encodeObject:_idTache forKey:keyIDTache];
	
    [encoder encodeObject:_titre forKey:keyTitre];
    [encoder encodeObject:_description forKey:keyDescription];
    [encoder encodeObject:_imageDescription forKey:keyDescriptionImage];
    
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
        _imageDescription = [decoder decodeObjectForKey:keyDescriptionImage];
        
        _commentaire = [decoder decodeObjectForKey:keyCommentaire];
        _imageCommentaire = [decoder decodeObjectForKey:keyCommentaireImage];
	}
	return self;
}

@end
