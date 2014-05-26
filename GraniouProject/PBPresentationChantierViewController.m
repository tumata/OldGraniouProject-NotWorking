//
//  PBPresentationChantierViewController.m
//  GraniouProject
//
//  Created by Philippe Tumata on 15/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBPresentationChantierViewController.h"
#import "PBChantier.h"
#import "PBUserSyncController.h"
#import "PBNetworking.h"
#import "PBTacheMonteurLeveeReserve.h"

@interface PBPresentationChantierViewController ()

@property (readwrite) NSDictionary *infosChantier;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar1;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar3;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar4;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar5;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar6;

@end

@implementation PBPresentationChantierViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeAllUIItemsFromPBChantier];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeAllUIItemsFromPBChantier {
    
    PBChantier *chantier = [PBChantier sharedChantier];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[[chantier getKeyThenValueNomChantier] objectAtIndex:1] attributes:underlineAttribute];
    
    [_labelTitre setAttributedText:title];
    _labelTitre.textColor = [UIColor blueColor];
    _labelTitre.font = [UIFont fontWithName:@"American Typewriter" size:24];
    
    NSArray *itemsArray = [[NSArray alloc] initWithObjects:_toolbar1, _toolbar2, _toolbar3, _toolbar4, _toolbar5, _toolbar6, nil];
    NSArray *infosArray = [chantier getTheSixInfosKeyThenValue];
    
    // Pour chaque barItem :
    for (int i = 0; i < itemsArray.count; i++) {
        int j = 0;
        
        // Pour chaque barButton :
        for (UIBarButtonItem *item in [[itemsArray objectAtIndex:i] items]) {
            
            // Si c'est le bon bouton, on set le texte
            if (j == 2) {
                if ([[infosArray objectAtIndex:i] count] >= 2) {
                    [item setTitle:[[infosArray objectAtIndex:i] objectAtIndex:1]];
                    [item setTintColor:[UIColor blackColor]];
                }
            }
            j++;
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"backToLoginScreen"]) {
        [[PBUserSyncController sharedUser] reinitializeUserAndChantierToZero];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - IB Actions

- (IBAction)actionDeconnexion:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"!!! ATTENTION !!!"
                                                    message:@"Avant de vous déconnecter, synchronisez vos données. \nTOUTES DONNÉES NON SYNCHRONISÉES SERONT PERDUES."
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"J'ai synchronisé", nil];
    [alert show];
}

- (IBAction)actionSynchro:(id)sender {
    [self synchroniserDonnees];
}

#pragma mark - fonction lorsque appui sur bouton deconnection

- (void)validationDeconnection {
    [[PBChantier sharedChantier] removeChantierFromUserDefaults];
    [[PBUserSyncController sharedUser] removeUserFromUserDefaults];
    
    [self performSegueWithIdentifier:@"backToLoginScreen" sender:self];
}

#pragma mark - functions related to Synchro

- (void)synchroniserDonnees {
    // On empeche l'utilisateur de toucher a la vue et navigation
    [self.view setUserInteractionEnabled:false];
    [self.navigationController setNavigationBarHidden:true animated:true];
    
    // Notifications une fois termine
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donneesSynchronisees:) name:@"pb.chantierFinishedSynchroYes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(donneesNonSynchronisees:) name:@"pb.chantierFinishedSynchroNo" object:nil];
    
    // On envoi les donnees puis on les recupere
    [[PBChantier sharedChantier] uploadChantierToServerThenDownload];
    
}

- (void)donneesSynchronisees:(id)sender {
    
    // On redonne droit a l'utilisateur de toucher a la vue et navigation
    [self.view setUserInteractionEnabled:true];
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sauvegarde réussie !"
                                                    message:@"Si vous le désirez, vous pouvez désormais vous déconnecter. \nLes données sont sur le serveur."
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    // Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierFinishedSynchroYes" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierFinishedSynchroNo" object:nil];
}

- (void)donneesNonSynchronisees:(id)sender {
    
    // On redonne droit a l'utilisateur de toucher a la vue et navigation
    [self.view setUserInteractionEnabled:true];
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sauvegarde échouée"
                                                    message:@"Nous ne pouvons garantir l'envoi des données. La connexion réseau a échoué pendant l'envoi."
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
    // Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierFinishedSynchroYes" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pb.chantierFinishedSynchroNo" object:nil];
}


#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:@"!!! ATTENTION !!!"] && (buttonIndex == 1)) {
        [self validationDeconnection];
    }
}


@end
