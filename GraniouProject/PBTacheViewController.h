//
//  TacheViewController.h
//  GraniouProject
//
//  Created by Philippe Tumata on 07/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBTakePhotoViewController.h"
#import "PBSaisieCommentaireViewController.h"
#import "PBTache.h"

@interface PBTacheViewController : UIViewController <TakePictureDelegate, SaisirCommentaireDelegate>

@property (strong, nonatomic) PBTache *tache;

@end

