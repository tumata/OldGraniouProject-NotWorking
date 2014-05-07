//
//  SaisieCommentaireViewController.h
//  PhotoPicker
//
//  Created by Philippe Tumata on 05/05/2014.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaisirCommentaireDelegate;


@interface SaisieCommentaireViewController : UIViewController

@property (nonatomic, assign) id<SaisirCommentaireDelegate> delegate;
- (void) initialiserCommentaire:(NSString *)com;

@end


@protocol SaisirCommentaireDelegate <NSObject>
@required
- (void)userFinishedSaisie:(NSString*)saisie;

@end