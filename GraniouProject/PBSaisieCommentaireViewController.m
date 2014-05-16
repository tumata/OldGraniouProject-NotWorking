//
//  SaisieCommentaireViewController.m
//  PhotoPicker
//
//  Created by Philippe Tumata on 05/05/2014.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import "PBSaisieCommentaireViewController.h"

@interface PBSaisieCommentaireViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentaireTextField;

@end

@implementation PBSaisieCommentaireViewController{
    PBTacheMonteurChantier *laTacheMonteurChantier;
    PBTacheMonteurLeveeReserve *laTacheMonteurLeveeReserve;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[_tache class]description] isEqualToString:[[PBTacheMonteurChantier class] description]]) {
        laTacheMonteurChantier = (PBTacheMonteurChantier *)_tache;
        laTacheMonteurLeveeReserve = nil;
    }
    if ([[[_tache class]description] isEqualToString:[[PBTacheMonteurLeveeReserve class] description]]) {
        laTacheMonteurLeveeReserve = (PBTacheMonteurLeveeReserve *)_tache;
        laTacheMonteurChantier = nil;
    }
    
    if (laTacheMonteurChantier) _commentaireTextField.text = laTacheMonteurChantier.commentaire;
    if (laTacheMonteurLeveeReserve) _commentaireTextField.text = laTacheMonteurLeveeReserve.commentaire;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)didSave:(id)sender
{
    if (_commentaireTextField.text.length)
    {
        if (laTacheMonteurChantier) {
            laTacheMonteurChantier.commentaire = _commentaireTextField.text;
            [_delegate userFinishedSaisie:laTacheMonteurChantier.commentaire];
        }
        if (laTacheMonteurLeveeReserve) {
            laTacheMonteurLeveeReserve.commentaire = _commentaireTextField.text;
            [_delegate userFinishedSaisie:laTacheMonteurLeveeReserve.commentaire];
        }
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
