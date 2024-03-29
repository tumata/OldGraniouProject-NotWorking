//
//  LoginViewController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 08/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBLoginViewController.h"
#import "PBUserSyncController.h"



@interface PBLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *textFieldID;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPSW;

@property (nonatomic) CGPoint viewCenterCoords;

@end


UITextField *currentFieldSelected;


@implementation PBLoginViewController


//-------------------------------------------------------
// Fonction se lancant des que la vue est loadee
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // On enregistre les notifications de Keyboard (entree/sortie ecran)
    [self registerForKeyboardNotifications];
    
    // On laisse la classe gerer le delegate des textfields
    self.textFieldID.delegate = self;
    self.textFieldPSW.delegate = self;

    // On recupere les coordonnes de base de la vue
    self.viewCenterCoords = self.view.center;
    
    // On s'abonne aux notifications de PBUserSyncController
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userNotLoggedNoInternet:) name:@"pb.notLoggedNoInternet" object:nil];
    
    if ([[PBUserSyncController sharedUser] wasLoggedBeforeLoginScreen]
        && [[NSUserDefaults standardUserDefaults] objectForKey:@"chantierEnregistre"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Déjà connecté"
                                                        message:@"Nous allons restaurer votre session"
                                                       delegate:self
                                              cancelButtonTitle:@"Restaurer la session"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.userLoadedFromUserDefaults" object:nil];
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.notLoggedNoInternet" object:nil];
    
    [super viewDidDisappear:animated];
}


//-------------------------------------------------------
// Cette fonction se lance en cas de probleme de memoire
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - KeyBoard notifications and slide

//-------------------------------------------------------
//  Notifications lorsque le clavier apparait / disparait
//
//      . Lorsqu'il apparait, appel du selector :
//          keyboardWasShown:
//      . Lorsqu'il disparait, appel du selector :
//          keyboardWillBeHidden:
//
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


//-------------------------------------------------------
// Called when the UIKeyboardWillShowNotification is sent
//
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //[self keyBoardSlide:kbSize.height];
    
    // On recupere la taille de la vue sans le keyboard dans aRect
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
//    NSLog(@"%f", currentFieldSelected.frame.origin.y);
//    NSLog(@"%f", aRect.origin.y);
    
    // Cette condition fait que la vue bouge uniquement si l'objet est caché par le keyboard
    //if (!CGRectContainsPoint(aRect, currentFieldSelected.frame.origin) ) {
        ////////////////////////////////////////////////////
        //  Possibilite d'ameliorer le positionnement ici //
        ////////////////////////////////////////////////////
        CGFloat deltaY = currentFieldSelected.frame.origin.y - aRect.origin.y;
        [self keyBoardSlide:deltaY/3 ];
    //}

    
}


//-------------------------------------------------------
// Called when the UIKeyboardWillHideNotification is sent
//
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self keyBoardSlide:0];
}



//-------------------------------------------------------
// Notification lorsque debut d'edit du textField
//
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // On pointe le textField courant selectionne
    currentFieldSelected = textField;
}


//-------------------------------------------------------
//   Notification lorsque fin d'edit du textField
//
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // On place le pointeur vers le textField courant a nil
    currentFieldSelected = nil;
}


//-------------------------------------------------------
// permet de supprimer le clavier si on touche autre part
//
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textFieldID isFirstResponder] && [touch view] != self.textFieldID) {
        [self.textFieldID resignFirstResponder];
    }
    if ([self.textFieldPSW isFirstResponder] && [touch view] != self.textFieldPSW) {
        [self.textFieldPSW resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}



//-------------------------------------------------------
//  Lorsqu'appui sur "retour", on enleve le KeyBoard
//
- (IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}


//-------------------------------------------------------
//    Permet de monter la View de "deltaY"
//
- (void)keyBoardSlide:(CGFloat)deltaY {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    self.view.center = CGPointMake(self.viewCenterCoords.x, self.viewCenterCoords.y - deltaY);
    [UIView commitAnimations];
}



#pragma mark - IBActions

//-------------------------------------------------------
//    Action sur le bouton connexion
//
- (IBAction)tryConnection:(id)sender {
    PBUserSyncController *user = [PBUserSyncController sharedUser];
    
    if (_textFieldID.text.length && _textFieldPSW.text.length) {
        if ([user tryLogin:_textFieldID.text password:_textFieldPSW.text]) {
            [self performSegueWithIdentifier:@"loadData" sender:self];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Identification impossible"
                                                        message:@"Login / Password non reconnus"
                                                       delegate:self
                                              cancelButtonTitle:@"Recommencer"
                                              otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - Notifications

//-------------------------------------------------------
//  Utilisateur non loggé et pas internet
//
- (void)userNotLoggedNoInternet:(NSNotification *)notif {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problème de connection"
                                                    message:@"Vous n'êtes pas identifiés et n'avez pas d'accès internet. Accès à l'application impossible"
                                                   delegate:self
                                          cancelButtonTitle:@"Réessayer"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}


# pragma mark - AlertView Delegate

//-------------------------------------------------------
//    Action sur le bouton cancel lorsque pas internet
//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Problème de connection"]) {
        [[PBUserSyncController sharedUser] downloadUsersFile];
    }
    if ([alertView.title isEqualToString:@"Déjà connecté"]) {
        [self performSegueWithIdentifier:@"loadData" sender:self];
    }
    
}

@end
