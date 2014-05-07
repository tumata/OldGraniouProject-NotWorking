//
//  Tache.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 01/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tache : NSObject

@property (readonly, copy, nonatomic) NSString      *titre;

@property (readonly, copy, nonatomic) NSString      *description;
@property (readonly, strong, nonatomic) UIImage     *imageDescription;

@property (readonly, copy, nonatomic) NSString      *commentaire;
@property (readonly, strong, nonatomic) UIImage     *imageCommentaire;


-(id)initWithName:(NSString *) name description:(NSString *)descr imageDescription:(UIImage *)imgDescr commentaire:(NSString *)comm imageCommentaire:(UIImage *)imgComm;

-(void) setImageCommentaire:(UIImage *) image;
-(void) setCommentaire:(NSString *) commentaire;

@end
