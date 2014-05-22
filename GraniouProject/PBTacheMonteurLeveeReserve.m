//
//  Tache.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBTacheMonteurLeveeReserve.h"
#import "NSString+DecodeToImage.h"


#define keyIDChantier                       @"idChantier"
#define keyIDTache                          @"id"

#define keyTitre                            @"tachePhotoTitre"
#define keyDescription                      @"tachePhotoContenu"
#define keyDescriptionImageDico             @"tachePhoto"
#define keyDescriptionImageDicoData         @"data"
#define keyDescriptionImageDicoExtension    @"extension"
#define keyDescriptionImageDicoName         @"name"

#define keyCommentaire                      @"commentaire"
#define keyCommentaireImageDico             @"image"
#define keyCommentaireImageDicoData         @"data"
#define keyCommentaireImageDicoExtension    @"extension"
#define keyCommentaireImageDicoName         @"name"



#define keyCompression 0.5

@interface PBTacheMonteurLeveeReserve ()

@property (readwrite) NSString          *titre;
@property (readwrite) NSString          *description;
@property (readwrite) UIImage           *imageDescription;

@end

@implementation PBTacheMonteurLeveeReserve


-(id)initTacheWithInfos:(NSDictionary *)tacheInfos {
    self = [super init];
    if (self) {
        
        // Identifiants associes a la tache
        //
        _idChantier = [tacheInfos objectForKey:keyIDChantier];
        _idTache = [tacheInfos objectForKey:keyIDTache];
        
        // Titre, description et image de la tache
        //
        _titre = [tacheInfos objectForKey:keyTitre];
        _description = [tacheInfos objectForKey:keyDescription];
        NSDictionary *dicoDescrImage = [tacheInfos objectForKey:keyDescriptionImageDico];
        if ([[dicoDescrImage description] length]) {
            NSString *imgStr = [dicoDescrImage objectForKey:keyDescriptionImageDicoData];
            if ([imgStr length]) {
                UIImage * imgUI= [imgStr decodeBase64ToImage];
                _imageDescription = [UIImage imageWithData:UIImageJPEGRepresentation(imgUI, 0.5)];
            }
        }
        else _imageDescription = nil;
    
        // Commentaire et image associes a la tache
        //
        _commentaire = [tacheInfos objectForKey:keyCommentaire];
        NSDictionary *dicoCommImage = [tacheInfos objectForKey:keyCommentaireImageDico];
        if ([[dicoCommImage description] length]) {
            NSString *imgStr = [dicoCommImage objectForKey:keyCommentaireImageDicoData];
            if ([imgStr length]) {
                _imageCommentaire = [imgStr decodeBase64ToImage];
            }
        }
        else _imageCommentaire = nil;
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
    [encoder encodeObject:_imageDescription forKey:keyDescriptionImageDico];
    
    [encoder encodeObject:_commentaire forKey:keyCommentaire];
    [encoder encodeObject:_imageCommentaire forKey:keyCommentaireImageDico];
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
        _imageDescription = [decoder decodeObjectForKey:keyDescriptionImageDico];
        
        _commentaire = [decoder decodeObjectForKey:keyCommentaire];
        _imageCommentaire = [decoder decodeObjectForKey:keyCommentaireImageDico];
	}
	return self;
}


#pragma mark - NSData serialization

/**
 *  Conversion de la tache en NSData
 *
 *  @return NSData* contenant les infos de la tache
 */
- (NSData *)tacheToData {
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSMutableData *body = [NSMutableData data];
    
    // Pour commencer la requete
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // Image
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@.jpg\"\r\n", [self getNomImageCommentaire]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(_imageCommentaire, keyCompression)]];
    
    // Id Tache
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n%@", _idTache] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Id Chantier
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"idChantier\"\r\n\r\n%@", _idChantier] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Commentaire
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"commentaire\"\r\n\r\n%@", _commentaire] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Pour terminer la requete
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (NSString *)getNomImageCommentaire {
    return [NSString stringWithFormat:@"image-%@-%@", _idChantier, _idTache];
}


@end
