//
//  PBNetworkingSendTaches.m
//  GraniouProject
//
//  Created by Philippe Tumata on 26/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBNetworkingSendTaches.h"
#import "PBNetworking.h"

#import "PBChantier.h"
#import "PBTacheMonteurLeveeReserve.h"
#import "PBTacheMonteurChantier.h"

#define urlToSendTacheChantier  @"http://ahmed-bacha.fr/send_tache_ios.php"
#define urlToSendTacheLR        @"http://ahmed-bacha.fr/send_ldr_ios.php"

@interface PBNetworkingSendTaches()

@property int tachesChantierSent;
@property int tachesLRSent;

@end



@implementation PBNetworkingSendTaches


static PBNetworkingSendTaches *_sharedInstance;



//-------------------------------------------------------
// Initialisation singleton
//
+ (void)initialize {
    if (self == [PBNetworkingSendTaches class]) {
        _sharedInstance = [[super alloc] init];
        _sharedInstance.tachesChantierSent = 0;
        _sharedInstance.tachesLRSent = 0;
    }
}


+ (void)sendAllTachesFromChantierToUrl {
    _sharedInstance.tachesChantierSent = 0;
    _sharedInstance.tachesLRSent = 0;
    
    [_sharedInstance sendTaches];
}


- (void)sendTaches {
    PBChantier *chantier = [PBChantier sharedChantier];
    
    // On envoi d'abord les taches chantier
    //
    if (_sharedInstance.tachesChantierSent < [chantier.tachesArray count]) {
    
        PBTacheMonteurChantier *tache = [[PBChantier sharedChantier] tachesArray][_sharedInstance.tachesChantierSent];
        [PBNetworking sendHttpPostTacheWithData:[tache tacheToData] toUrlWithString:urlToSendTacheChantier delegate:self];
        
        _sharedInstance.tachesChantierSent++;
    }
    // Puis on envoi les taches Levee Reserve
    //
    else {
        if (_sharedInstance.tachesLRSent < [chantier.tachesLRArray count]) {
        
            PBTacheMonteurLeveeReserve *tacheLR = [[PBChantier sharedChantier] tachesLRArray][_sharedInstance.tachesLRSent];
            [PBNetworking sendHttpPostTacheWithData:[tacheLR tacheToData] toUrlWithString:urlToSendTacheLR delegate:self];
            
            _sharedInstance.tachesLRSent++;
        }
        else {
            // Tout a ete uploade : envoi de la notification
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierFinishedUploadingYes" object:nil];
        }
    }
    
}


#pragma mark - NSURLSessionData Delegate Methods

//-------------------------------------------------------
// Lancé une fois la data depuis le serveur récuperée
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
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
        [_sharedInstance sendTaches];
        NSLog(@"Reussi!!!!! (reponse du serveur)");
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierFinishedUploadingNo" object:nil];
        NSLog(@"Erreur");
    }
    
    
}



@end
