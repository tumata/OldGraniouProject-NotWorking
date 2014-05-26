//
//  LoadDataController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 09/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//


#import "PBLoadChantierController.h"
#import "PBUserSyncController.h"
#import "PBNetworking.h"
#import "PBChantier.h"

@interface PBLoadChantierController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PBLoadChantierController {
    NSTimer *timer;
}


//-------------------------------------------------------
// Lance l'indicateur d'activité + lance la requette HTTP
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notification lorsque chantier chargé depuis le serveur
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chantierLoaded:) name:@"pb.chantierLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chantierNotLoaded:) name:@"pb.chantierNotLoaded" object:nil];

    
    
    [self startLoadingChantierForActiveUser];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierNotLoaded" object:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-------------------------------------------------------
// Lance l'indicateur d'activité + lance la requette HTTP
//
-(void)startLoadingChantierForActiveUser {
    
    
    [_activityIndicator startAnimating];
    
    PBUserSyncController *user = [PBUserSyncController sharedUser];
    
    //-------------------------------------------------------
    //    Il etait loggé avant de lancer l'appli
    //
    if ([user wasLoggedBeforeLoginScreen]) {
        
        [[PBChantier sharedChantier] getChantierFromUserDefaults];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(segueCanNowBePerformed:) userInfo:NULL repeats:NO];
        [_activityIndicator stopAnimating];

    }
    //-------------------------------------------------------
    //    Il vient d'entrer ses identifiants
    //
    else {
        [[PBChantier sharedChantier] loadChantierFromServer];
    }
    
}


//-------------------------------------------------------
// On passe fenetre suivante, tout s'est bien déroulé
//
- (void)segueCanNowBePerformed:(id)sender {
    [self performSegueWithIdentifier:@"dataLoaded" sender:self];
}



#pragma mark - Notifications

- (void)chantierLoaded:(NSNotification *)notif {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(segueCanNowBePerformed:) userInfo:NULL repeats:NO];
}

- (void)chantierNotLoaded:(NSNotification *)notif {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur réseau"
                                                    message:@"Merci de recommencer"
                                                   delegate:self
                                          cancelButtonTitle:@"Réessayer"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}


#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:@"backToLogin" sender:self];
}

@end
