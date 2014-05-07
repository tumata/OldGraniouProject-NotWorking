//
//  TacheTestViewController.h
//  GraniouProject
//
//  Created by Philippe Tumata on 07/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLViewController.h"
#import "SaisieCommentaireViewController.h"
#import "Tache.h"

@interface TacheViewController : UIViewController <TakePictureDelegate, SaisirCommentaireDelegate>

@property (strong, nonatomic, readwrite) Tache *tache;

@end
