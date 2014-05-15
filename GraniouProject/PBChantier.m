//
//  PBChantier.m
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBChantier.h"
#import "PBUserSyncController.h"
#import "PBNetworking.h"


//URL ou envoyer la data
#define destinationUrl @"http://ahmed-bacha.fr/json_data.php"

#define keyChantiers    @"chantiers"

#define keyNom          @"nom"
#define keyAdresse      @"adresse"
#define keyAmenageur    @"amenageur"
#define keyPartenaire   @"partenaire"
#define keyDate         @"ladate"
#define keyRecetteeur   @"recetteur"
#define keyCodeSite     @"codesite"
#define keyPhase        @"phase"
#define keyBrin         @"brin"
#define keyLigne        @"ligne"
#define keyPk           @"pk"
#define keyRegion       @"region"
#define keyID           @"id"



@interface PBChantier ()

@property (nonatomic, strong) NSURLSession *session;

@end





@implementation PBChantier

static PBChantier *_sharedInstance;



//-------------------------------------------------------
// Initialisation singleton
//
+ (void)initialize {
    if (self == [PBChantier class]) {
        _sharedInstance = [[super alloc] init];
    }
}

//-------------------------------------------------------
// Recuperation Singleton
//
+ (PBChantier *)sharedChantier {
    return _sharedInstance;
}


#pragma mark - Fonctions publiques

#pragma mark Actions sur le réseau

//-------------------------------------------------------
// Upload le chantier puis download la mise a jour
//
- (void)uploadChantierToServerThenDownload {
    
    //------------------------------
    //        gerer l'envoi       //
    //------------------------------
    
    NSString *data = @"id=";
    data = [data stringByAppendingString:[[PBUserSyncController sharedUser] idChantier]];
    
    [PBNetworking sendHttpPostWithData:data toURLWithString:destinationUrl delegate:self];
    
}

//-------------------------------------------------------
// Recupere le chantier depuis le serveur
//
- (void)loadChantierFromServer {
    
    NSString *data = @"id=";
    data = [data stringByAppendingString:[[PBUserSyncController sharedUser] idChantier]];
    
    [PBNetworking sendHttpPostWithData:data toURLWithString:destinationUrl delegate:self];
}

//-------------------------------------------------------
// Upload le chantier sur le serveur
//
- (void)uploadChantierToServer {

    
}

#pragma mark Actions sur UsersDefault

//-------------------------------------------------------
// Sauvegarde le chantier dans les userDefaults
//
- (BOOL)saveChantierToUserDefaults {
    
    return true;
}


//-------------------------------------------------------
// Recupere le chantier depuis le UserDefault
//
- (BOOL)getChantierFromUserDefaults {
    
    return true;
}


#pragma mark - Getters and Setters


- (NSArray *)getTheSixInfosKeyThenValue {
    NSMutableArray * theSixInfos = [[NSMutableArray alloc] init];
    
    [theSixInfos addObject:[self getKeyThenValueAdresse]];
    [theSixInfos addObject:[self getKeyThenValueCodeSite]];
    [theSixInfos addObject:[self getKeyThenValueBrin]];
    [theSixInfos addObject:[self getKeyThenValuePhase]];
    [theSixInfos addObject:[self getKeyThenValueAmenageur]];
    [theSixInfos addObject:[self getKeyThenValueDate]];
    
    NSArray *array = [[NSArray alloc] initWithArray:theSixInfos];
    return array;
}

- (NSArray *)getKeyThenValueNomChantier {
    return [[NSArray alloc] initWithObjects:keyNom,
            [_infosChantier objectForKey:keyNom] , nil];
}

- (NSArray *)getKeyThenValueAmenageur {
    return [[NSArray alloc] initWithObjects:keyAmenageur,
            [_infosChantier objectForKey:keyAmenageur] , nil];
}

- (NSArray *)getKeyThenValuePartenaire {
    return [[NSArray alloc] initWithObjects:keyPartenaire,
            [_infosChantier objectForKey:keyPartenaire] , nil];
}

- (NSArray *)getKeyThenValueAdresse {
    return [[NSArray alloc] initWithObjects:keyAdresse,
            [_infosChantier objectForKey:keyAdresse] , nil];
}

- (NSArray *)getKeyThenValueDate {
    return [[NSArray alloc] initWithObjects:keyDate,
            [_infosChantier objectForKey:keyDate] , nil];
}

- (NSArray *)getKeyThenValueCodeSite {
    return [[NSArray alloc] initWithObjects:keyCodeSite,
            [_infosChantier objectForKey:keyCodeSite] , nil];
}

- (NSArray *)getKeyThenValueBrin {
    return [[NSArray alloc] initWithObjects:keyBrin,
            [_infosChantier objectForKey:keyBrin] , nil];
}

- (NSArray *)getKeyThenValuePhase {
    return [[NSArray alloc] initWithObjects:keyPhase,
            [_infosChantier objectForKey:keyPhase] , nil];
}





#pragma mark - Fonctions privées 

//-------------------------------------------------------
// Initialise le chantier avec le (id)JSON
//
- (BOOL)initializeChantierWithJSON:(id)jsonObjects {
    
    NSArray *chantier = [jsonObjects objectForKey:keyChantiers];
    _infosChantier = [chantier objectAtIndex:0];
    
    
    
    NSLog(@"%@", jsonObjects);
    
    return true;
}


//-------------------------------------------------------
// Fonction de convertion du chantier en JSON
//
- (BOOL)convertChantierToJSON {
    
    
    return true;
}




#pragma mark - NSURLSessionData Delegate Methods

//-------------------------------------------------------
// Lancé une fois la data depuis le serveur récuperée
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    
    NSError *error;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error == nil) {
        NSLog(@"%s : Received JSon : %@", __func__, jsonObjects);
        
        [[PBChantier sharedChantier] initializeChantierWithJSON:jsonObjects];
    }
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
        [_session invalidateAndCancel];

        // Une fois finit faire cette notification :
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierLoaded" object:self];
        
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierNotLoaded" object:self];
    }
    
    
}



@end