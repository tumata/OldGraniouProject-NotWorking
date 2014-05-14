//
//  LoadDataController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 09/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//


//URL ou envoyer la data
#define destinationUrl @"http://ahmed-bacha.fr/json_data.php"



#import "PBLoadChantierController.h"
#import "PBUserSyncController.h"
#import "PBNetworking.h"
#import "PBChantier.h"

@interface PBLoadChantierController ()

@property (nonatomic, strong) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) BOOL jSONObjectHasBeenSuccessfullySetToChantier;

@end

@implementation PBLoadChantierController {
    NSTimer *timer;
}


//-------------------------------------------------------
// Vue chargée, on commence a charger le chantier :
// 1. Utilisateur déja connecté avant lancement application
//      -> On recupere les données depuis UserDefault
// 2. Utilisateur vient de se connecter :
//      -> On va recuperer les données sur internet
//
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoadingChantierForActiveUser];
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
    _jSONObjectHasBeenSuccessfullySetToChantier = FALSE;
    [_activityIndicator startAnimating];
    
    NSString *data = @"id=";
    data = [data stringByAppendingString:[[PBUserSyncController sharedUser] idChantier]];
    
    [PBNetworking sendHttpPostWithData:data toURLWithString:destinationUrl delegate:self];
}


//-------------------------------------------------------
// Action une fois le chantier chargé dans PBChantier
//
- (void)chantierSuccessfullyDownloaded {
    
    if (_jSONObjectHasBeenSuccessfullySetToChantier) {
        NSLog(@"%s : Téléchargement réussi et JSON converti en Chantier", __func__);
        // Timer pour éviter que le temps de chargement soit trop court et que le segue se déclenche trop tot
        timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(segueCanNowBePerformed:) userInfo:NULL repeats:NO];
    }
    else {
        NSLog(@"%s : Téléchargement réussi mais JSON non converti en Chantier", __func__);
    }
}

- (void)chantierCouldNotBeDownloaded:(NSError *)error {
    NSLog(@"Error %@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
}

- (void)segueCanNowBePerformed:(id)sender {
    NSLog(@"Timer fired!");
    [self performSegueWithIdentifier:@"dataLoaded" sender:self];
}


#pragma mark - NSURLSessionData Delegate Methods

//-------------------------------------------------------
// Lancé une fois la data depuis le serveur récuperée
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    _jSONObjectHasBeenSuccessfullySetToChantier = false;
    
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if (error == nil) {
        NSLog(@"%s : Received JSon : %@", __func__, jsonObjects);
        
        if ([[PBChantier sharedChantier] setChantierWithJSON:jsonObjects]) {
            _jSONObjectHasBeenSuccessfullySetToChantier = true;
        }
    }
}

//-------------------------------------------------------
// Une fois la connection terminée, fonction appelée.
// Permet de savoir également si appareil Connecté
//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    
    if(error == nil)
    {
        [_session invalidateAndCancel];
        [self chantierSuccessfullyDownloaded];
    }
    else {
        [self chantierCouldNotBeDownloaded:error];
    }
    
    
}

@end
