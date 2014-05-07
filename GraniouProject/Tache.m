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

@synthesize titre = _titre;
@synthesize description = _description;
@synthesize imageDescription = _imageDescription;

@synthesize commentaire = _commentaire;
@synthesize imageCommentaire = _imageCommentaire;


// Constructeur
-(id)initWithName:(NSString *)name description:(NSString *)descr imageDescription:(UIImage *)imgDescr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm
{
    
    self = [super init];
    if (self) {
        _titre = [name copy];
        _description = [descr copy];
        _imageDescription = [imgDescr copy];
        
        _commentaire = [comm copy];
        _imageCommentaire = [imgComm copy];
        
    }
    return self;
}

- (id)init {
    // Forward to the "designated" initialization method
    return [self initWithName:@"Erreur" description:nil imageDescription:nil commentaire:nil imageCommentaire:nil];
}



-(void) setImageCommentaire:(UIImage *)image
{
    if (_imageCommentaire)
    {
        ///// ICI MODIFIER
        //[_imageCommentaire];
    }
    _imageCommentaire = image;
}

-(void) setCommentaire:(NSString *) commentaire
{
    _commentaire = commentaire;
}



@end
