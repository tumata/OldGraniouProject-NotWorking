//
//  PBDetailedTacheMonteurChantierViewController.h
//  GraniouProject
//
//  Created by Philippe Tumata on 16/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBTakePhotoViewController.h"
#import "PBSaisieCommentaireViewController.h"
#import "PBTacheMonteurChantier.h"

@interface PBDetailedTacheMonteurChantierViewController : UIViewController <TakePictureDelegate, SaisirCommentaireDelegate>

@property (strong, nonatomic) PBTacheMonteurChantier *tache;

@end
