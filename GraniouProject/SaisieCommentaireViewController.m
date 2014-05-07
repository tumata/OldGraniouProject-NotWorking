//
//  SaisieCommentaireViewController.m
//  PhotoPicker
//
//  Created by Philippe Tumata on 05/05/2014.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import "SaisieCommentaireViewController.h"

@interface SaisieCommentaireViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (nonatomic, assign) NSString *commentaire;

@end

@implementation SaisieCommentaireViewController

@synthesize textField = _textField;
@synthesize commentaire = _commentaire;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialiserCommentaire:(NSString *)com
{
    _commentaire = com;
    [_textField setText: _commentaire];
    NSLog(@"%@", _commentaire);
}

- (IBAction)didCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)didSave:(id)sender
{
    if (_textField.text.length)
    {
        [_delegate userFinishedSaisie:_textField.text];
        [self.navigationController popViewControllerAnimated:true];
    }
}


@end
