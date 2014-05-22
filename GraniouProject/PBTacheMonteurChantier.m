//
//  PBTacheMonteurChantier.m
//  GraniouProject
//
//  Created by Philippe Tumata on 16/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBTacheMonteurChantier.h"
#import "NSString+DecodeToImage.h"

#define keyIDChantier       @"idChantier"
#define keyIDTache          @"id"

#define keyTitre            @"titreTache"
#define keyDescription      @"contenuTache"

#define keyCommentaire      @"commentaire"
#define keyCommentaireImage @"image"

#define keyCompression 0.5

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
        
        NSString *stringImageCommentaire = [tacheInfos objectForKey:keyCommentaireImage];
        if ([stringImageCommentaire length]) {
            _imageCommentaire = [stringImageCommentaire decodeBase64ToImage];
        
        }
        else {
            _imageCommentaire = nil;
        }
    }
    return self;
}


#pragma mark - encode / decode

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
