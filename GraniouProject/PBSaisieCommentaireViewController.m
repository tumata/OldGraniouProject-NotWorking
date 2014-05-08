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

@implementation PBSaisieCommentaireViewController

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
    _commentaireTextField.text = _tache.commentaire;
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
        _tache.commentaire = _commentaireTextField.text;
        [_delegate userFinishedSaisie:_tache.commentaire];
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
