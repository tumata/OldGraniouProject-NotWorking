//
//  SaisieCommentaireViewController.h
//  PhotoPicker
//
//  Created by Philippe Tumata on 05/05/2014.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PBTache.h"

@protocol SaisirCommentaireDelegate;


@interface PBSaisieCommentaireViewController : UIViewController

@property (nonatomic, assign) id<SaisirCommentaireDelegate> delegate;
@property (strong, nonatomic) PBTache *tache;

@end


@protocol SaisirCommentaireDelegate <NSObject>
@required
- (void)userFinishedSaisie:(NSString*)saisie;

@end