//
//  PBDetailedTacheMonteurChantierViewController.m
//  GraniouProject
//
//  Created by Philippe Tumata on 16/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#define MY_LABEL_HEIGHT 25
#define MY_BUTTON_HEIGHT 30
#define MY_TEXTVIEW_HEIGHT 100
#define MY_IMAGEVIEW_HEIGHT 200

#define MY_SPACE_BEFORE_TITLE 10
#define MY_SPACE_AFTER_TITLE 20
#define MY_SPACE_AFTER_LABEL 10
#define MY_SPACE_AFTER_TEXTVIEW 20
#define MY_SPACE_FOR_SECTION 40


#import "PBDetailedTacheMonteurChantierViewController.h"

@interface PBDetailedTacheMonteurChantierViewController ()

@property (nonatomic) CGRect                frameScrollRect;
@property (nonatomic) CGRect                lastFrameRect;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView        *insideView;

@property (nonatomic, strong) UILabel       *titreLabel;
@property (nonatomic, strong) UILabel       *descriptionLabelStatic;
@property (nonatomic, strong) UITextView    *descriptionTextView;

@property (nonatomic, strong) UILabel       *commentaireLabelStatic;
@property (nonatomic, strong) UITextView    *commentaireTextView;
@property (nonatomic, strong) UIImageView   *commentaireImage;

@property (nonatomic, strong) UIButton      *boutonAddCommentaire;
@property (nonatomic, strong) UIButton      *boutonAddImage;


@end

@implementation PBDetailedTacheMonteurChantierViewController

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
    
    //    _tache = [[PBTacheMonteurLeveeReserve alloc]initWithIdChantier:1
    //                                       idTache:1
    //                                         name:@"Tache 1"
    //                                  description:@"Voici la dercription de la tache et c'est plutot sympas de voir que ca marche très bien n'est pas ? Voila donc vous avez ça a faire et puis ça et puis aussi ça car quand on s'amuse on ne compte pas. N'est pas ? Allez, ciao"
    //                              imageDescription:[UIImage imageNamed:@"fond-1.jp"]
    //                                   commentaire:@"Voici la dercription de la tache et c'est plutot sympas de voir que ca marche très bien n'est pas ? Voila donc vous avez ça a faire et puis ça et puis aussi ça car quand on s'amuse on ne compte pas. N'est pas ? Allez, ciao"
    //                              imageCommentaire:[UIImage imageNamed:@"fond-1.jpg"]];
    
    _tache = [[[PBChantier sharedChantier] tachesArray] objectAtIndex:0];
    
    [self initialisationViews];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - initialisation insideView

-(void) initialisationViews
{
    // Bouton "Saubegarder" dans la barre de navigation
    UIBarButtonItem *boutonSauvegarder = [[UIBarButtonItem alloc]
                                          initWithTitle:@"Valider tâche"
                                          style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(boutonSaveTouched:)];
    self.navigationItem.rightBarButtonItem = boutonSauvegarder;
    self.navigationItem.hidesBackButton = true;
    
    
    // Taille du Scroll
    _frameScrollRect = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20);
    
    // Zone de scroll
    _scrollView = [[UIScrollView alloc] initWithFrame:_frameScrollRect];
    
    
    // Vue qui va contenir les elements. A l'interieur de la zone de scroll.
    _insideView = [[UIView alloc] initWithFrame:CGRectMake(_frameScrollRect.origin.x,
                                                           _frameScrollRect.origin.y,
                                                           _frameScrollRect.size.width,
                                                           20)];
    
    // Rectangle pour elements de la vue
    _lastFrameRect = CGRectMake(_frameScrollRect.origin.x + 20,
                                _frameScrollRect.origin.y + 20,
                                _frameScrollRect.size.width - 40,
                                0);
    
    
    
    NSLog(@"_lastFrameRect");
    NSLog(@"lastFrame origine Y depart : %f", _lastFrameRect.origin.y);
    NSLog(@"%f", _frameScrollRect.size.height);
    
    ///////////////////////////////////////////////////////
    //// Creation et placement des elements dans la vue ///
    ///////////////////////////////////////////////////////
    //   Utiliser la fonction getRectForElement pour    ///
    //   recuperer la taille de l'element a placer      ///
    ///////////////////////////////////////////////////////
    
    // _titreLabel
    ///////////////////////////////////////////////////////
    _titreLabel = [[UILabel alloc] initWithFrame:
                   [self getRectForElementWithHeight:MY_LABEL_HEIGHT
                             andSpaceWithLastElement:MY_SPACE_BEFORE_TITLE]];
    _titreLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    _titreLabel.textAlignment = NSTextAlignmentCenter;
    [_titreLabel setText:_tache.titre];
    [_insideView addSubview:_titreLabel];
    
    // _descriptionLabelStatic
    ///////////////////////////////////////////////////////
    _descriptionLabelStatic = [[UILabel alloc] initWithFrame:
                               [self getRectForElementWithHeight:MY_LABEL_HEIGHT
                                         andSpaceWithLastElement:MY_SPACE_AFTER_TITLE]];
    _descriptionLabelStatic.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
    [_descriptionLabelStatic setText:@"Description :"];
    [_insideView addSubview:_descriptionLabelStatic];
    
    // _descriptionTextView
    ///////////////////////////////////////////////////////
    _descriptionTextView = [[UITextView alloc] initWithFrame:
                            [self getRectForElementWithHeight:MY_TEXTVIEW_HEIGHT
                                      andSpaceWithLastElement:MY_SPACE_AFTER_LABEL]];
    _descriptionTextView.font = [UIFont fontWithName:@"TrebuchetMS" size:15];
    _descriptionTextView.textAlignment = NSTextAlignmentJustified;
    [_descriptionTextView setText:_tache.description];
    [_descriptionTextView setEditable:false];
    [_insideView addSubview:_descriptionTextView];
    
    
    // _commentaireLabelStatic
    ///////////////////////////////////////////////////////
    _commentaireLabelStatic = [[UILabel alloc] initWithFrame:
                               [self getRectForElementWithHeight:MY_LABEL_HEIGHT
                                         andSpaceWithLastElement:MY_SPACE_FOR_SECTION]];
    _commentaireLabelStatic.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
    [_commentaireLabelStatic setText:@"Vos commentaires :"];
    [_insideView addSubview:_commentaireLabelStatic];
    
    // Si commentaire deja enregistré :
    ///////////////////////////////////////////////////////
    if (_tache.commentaire.length)
    {
        // _commentaireTextView
        ///////////////////////////////////////////////////////
        _commentaireTextView = [[UITextView alloc] initWithFrame:
                                [self getRectForElementWithHeight:MY_TEXTVIEW_HEIGHT
                                          andSpaceWithLastElement:MY_SPACE_AFTER_LABEL]];
        _commentaireTextView.font = [UIFont fontWithName:@"TrebuchetMS" size:15];
        _commentaireTextView.textAlignment = NSTextAlignmentJustified;
        [_commentaireTextView setText:_tache.commentaire];
        [_commentaireTextView setEditable:false];
        [_insideView addSubview:_commentaireTextView];
        
        // _boutonAddCommentaire : modifier commentaire
        ///////////////////////////////////////////////////////
        _boutonAddCommentaire = [UIButton buttonWithType:UIButtonTypeSystem];
        _boutonAddCommentaire.frame = [self getRectForElementWithHeight:MY_BUTTON_HEIGHT
                                                andSpaceWithLastElement:MY_SPACE_AFTER_TEXTVIEW];
        [_boutonAddCommentaire setTitle:@"Modifier commentaire" forState:UIControlStateNormal];
        _boutonAddCommentaire.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        [_boutonAddCommentaire addTarget:self action:@selector(boutonAddCommentaireTouched:) forControlEvents:UIControlEventTouchUpInside];        [_insideView addSubview:_boutonAddCommentaire];
    }
    else
    {
        // _boutonAddCommentaire : ajouter commentaire
        ///////////////////////////////////////////////////////
        _boutonAddCommentaire = [UIButton buttonWithType:UIButtonTypeSystem];
        [_boutonAddCommentaire setFrame:[self getRectForElementWithHeight:MY_BUTTON_HEIGHT
                                                  andSpaceWithLastElement:MY_SPACE_AFTER_TEXTVIEW]];
        [_boutonAddCommentaire setTitle:@"Ajouter commentaire" forState:UIControlStateNormal];
        _boutonAddCommentaire.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        [_boutonAddCommentaire addTarget:self action:@selector(boutonAddCommentaireTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_insideView addSubview:_boutonAddCommentaire];
        
    }
    
    
    // _commentaireImage
    ///////////////////////////////////////////////////////
    if (_tache.imageCommentaire)
    {
        _commentaireImage = [[UIImageView alloc] initWithFrame:
                             [self getRectForElementWithHeight:MY_IMAGEVIEW_HEIGHT
                                       andSpaceWithLastElement:MY_SPACE_AFTER_TEXTVIEW]];
        [_commentaireImage setImage:_tache.imageCommentaire];
        _commentaireImage.contentMode = UIViewContentModeScaleAspectFit;
        [_insideView addSubview:_commentaireImage];
        
        // _boutonAddImage : ajouter une image
        ///////////////////////////////////////////////////////
        _boutonAddImage = [UIButton buttonWithType:UIButtonTypeSystem];
        [_boutonAddImage setFrame:[self getRectForElementWithHeight:MY_BUTTON_HEIGHT
                                            andSpaceWithLastElement:MY_SPACE_AFTER_TEXTVIEW]];
        [_boutonAddImage setTitle:@"Changer la photo" forState:UIControlStateNormal];
        _boutonAddImage.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        [_boutonAddImage addTarget:self action:@selector(boutonAddImageTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_insideView addSubview:_boutonAddImage];
    }
    else
    {
        // _boutonAddImage : ajouter une image
        ///////////////////////////////////////////////////////
        _boutonAddImage = [UIButton buttonWithType:UIButtonTypeSystem];
        [_boutonAddImage setFrame:[self getRectForElementWithHeight:MY_BUTTON_HEIGHT
                                            andSpaceWithLastElement:MY_SPACE_AFTER_TEXTVIEW]];
        [_boutonAddImage setTitle:@"Joindre une photo" forState:UIControlStateNormal];
        _boutonAddImage.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        [_boutonAddImage addTarget:self action:@selector(boutonAddImageTouched:) forControlEvents:UIControlEventTouchUpInside];
        [_insideView addSubview:_boutonAddImage];
    }
    
    // On ajoute un espacement tout en bas
    [self getRectForElementWithHeight:0 andSpaceWithLastElement:20];
    
    // Ajout du tout a la vue
    [_scrollView addSubview:_insideView];
    [_scrollView setContentSize:_insideView.frame.size];
    [self.view addSubview:_scrollView];
}

// Fonction permettant de recuperer un CGRect a la bonne taille pour les elements de la vue
// Met automatiquement a jour l'origine de lastFrameRect
-(CGRect)getRectForElementWithHeight:(CGFloat)height andSpaceWithLastElement:(CGFloat)space
{
    //NSLog(@"Origine avant ajout espace : %f -> +%f", _lastFrameRect.origin.y, space);
    
    [self updateLastFrameRectOriginAddY:space];
    CGRect rectangle = CGRectMake(_lastFrameRect.origin.x,
                                  _lastFrameRect.origin.y,
                                  _lastFrameRect.size.width,
                                  height);
    [self updateLastFrameRectOriginAddY:height];
    [self updateInsideViewBoundsAddY:(height + space)];
    
    /*
     NSLog(@"Origine du rectangle : %f", rectangle.origin.y);
     NSLog(@"+ %f", height);
     NSLog(@"InsideView total height : %f", _insideView.frame.size.height);
     NSLog(@" ");
     */
    
    return rectangle;
}

// Mise a jour de l'origine de lastFraleRect
-(void)updateLastFrameRectOriginAddY:(CGFloat)heightToAdd
{
    _lastFrameRect.origin.y += heightToAdd;
}

// Mise a jour de la hauteur de la vue interne au scrollView
-(void)updateInsideViewBoundsAddY:(CGFloat)heightToAdd
{
    [_insideView setFrame:CGRectMake(_insideView.frame.origin.x,
                                     _insideView.frame.origin.y,
                                     _insideView.frame.size.width,
                                     (_insideView.frame.size.height + heightToAdd))];
}




#pragma mark - Actions sur les boutons

// Ajouter/modifier commentaire touché
-(void)boutonAddCommentaireTouched:(id)sender
{
    [self performSegueWithIdentifier:@"toSaisieCommentaire" sender:self];
}

// Ajouter photo touché
-(void)boutonAddImageTouched:(id)sender
{
    [self performSegueWithIdentifier:@"toGetPicture" sender:self];
}

// Valider Tache touché
-(void)boutonSaveTouched:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - TakePictureDelegate

- (void)userDidChooseImage:(UIImage *)imageChosen
{
    // Mise a jour modèle
    _tache.imageCommentaire = imageChosen;
    // Mise a jour vue
    _commentaireImage.image = _tache.imageCommentaire;
}

#pragma mark - SaisirCommentaireDelegate

- (void)userFinishedSaisie:(NSString *)saisie
{
    // Mise a jour modele
    _tache.commentaire = saisie;
    // Mise a jour vue
    _commentaireTextView.text = _tache.commentaire;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toGetPicture"])
    {
        PBTakePhotoViewController *vc = [segue destinationViewController];
        vc.delegate = self;
    }
    
    if ([[segue identifier] isEqualToString:@"toSaisieCommentaire"])
    {
        PBSaisieCommentaireViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        NSLog(@"ok");
        [vc setTache:_tache];
        NSLog(@"ok2");
    }
}



@end
