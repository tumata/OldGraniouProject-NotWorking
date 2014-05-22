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
    // Tester si donnees synchronisees
    // Si données synchronisees :
    
        [[PBChantier sharedChantier] removeChantierFromUserDefaults];
        [[PBUserSyncController sharedUser] removeUserFromUserDefaults];
    
    [self performSegueWithIdentifier:@"backToLoginScreen" sender:self];
}

- (IBAction)actionSynchro:(id)sender {
    PBTacheMonteurChantier *tache = [[PBChantier sharedChantier] tachesArray][0];
    [PBNetworking sendHttpPostTacheWithData:[tache tacheToData] toUrlWithString:@"http://www.ahmed-bacha.fr/send_tache_ios.php" delegate:self];
}



#pragma mark - NSURLSessionData Delegate Methods

//-------------------------------------------------------
// Lancé une fois la data depuis le serveur récuperée
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
    //NSString *theReply = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSLog(@"Reponse : %@", theReply);
}

//-------------------------------------------------------
// Une fois la connection terminée, fonction appelée.
// Permet de savoir également si appareil Connecté
//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    
    if(error == nil)
    {
        NSLog(@"Reussi!!!!! (reponse du serveur)");
    }
    else {
        NSLog(@"Erreur");
    }
    
    
}


@end
