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
#import "PBTacheMonteurLeveeReserve.h"


//User defaults
#define keyChantierForUserDefault       @"chantierEnregistre"

#define keyInfosChantierForUserDefault  @"informationsChantier"
#define keyIDChantierForUserDefault     @"identifiantChantier"
#define keyTachesArrayForUserDefault    @"listeDesTaches"
#define keyTachesLRArrayForUserDefault  @"listeDesTachesLR"

//URL ou envoyer la data
//#define destinationUrl @"http://ahmed-bacha.fr/json_get_all.php"
#define destinationUrl @"http://ahmed-bacha.fr/roma.php"

#define keyChantiersJSON    @"chantiers"
#define keyTachesJSON       @"taches"
#define keyTachesLRJSON     @"leveeReserve"

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
@property (nonatomic, strong) NSMutableData *gatherAllData;

@property (readwrite) NSDictionary *infosChantier;
@property int i;

@end





@implementation PBChantier

static PBChantier *_sharedInstance;



//-------------------------------------------------------
// Initialisation singleton
//
+ (void)initialize {
    if (self == [PBChantier class]) {
        _sharedInstance = [[super alloc] init];
        _sharedInstance.i = 0;
        _sharedInstance.gatherAllData = [NSMutableData data];
    }
}

//-------------------------------------------------------
// Recuperation Singleton
//
+ (PBChantier *)sharedChantier {
    return _sharedInstance;
}


#pragma mark - Fonctions publiques

- (void)reinitializeToZero {
    _sharedInstance.infosChantier = nil;
    _sharedInstance.tachesArray = nil;
    _sharedInstance.tachesLRArray = nil;
    _sharedInstance.idChantier = nil;
}

#pragma mark Actions sur le réseau

//-------------------------------------------------------
// Upload le chantier puis download la mise a jour
//
- (void)uploadChantierToServerThenDownload {
    
    //------------------------------
    //        gerer l'envoi       //
    //------------------------------
    
    // Supprimer les données dans userDefault une fois envoi reussi
    
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

    // Archiving calls encodeWithCoder: on the singleton instance.
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_sharedInstance] forKey:keyChantierForUserDefault];
    
    // Sauvegarde persistante
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return true;
}


//-------------------------------------------------------
// Recupere le chantier depuis le UserDefault
//
- (BOOL)getChantierFromUserDefaults {
    
    // Unarchiving calls initWithCoder: on the singleton instance.
    [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:keyChantierForUserDefault]];
    
    return true;
}

//-------------------------------------------------------
// Efface les informations de UserDefaults, tout a été uploadé
//

- (BOOL)removeChantierFromUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:keyChantierForUserDefault]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:keyChantierForUserDefault];
        return true;
    }
    else return false;
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
    
    /*----------------------------------------*/
    /*   On recupere les infos chantier       */
    /*----------------------------------------*/
    NSArray *chantier = [jsonObjects objectForKey:keyChantiersJSON];
    if ([chantier count]) {
        _infosChantier = [chantier objectAtIndex:0];
    }
    chantier = nil;
    
    
    /*----------------------------------------*/
    /* On recupere les TachesMonteurChantier  */
    /*----------------------------------------*/
    NSArray *taches = [jsonObjects objectForKey:keyTachesJSON];
    NSMutableArray *tempTachesArray = [[NSMutableArray alloc] init];
    
    if ([taches count]) {
        for (NSDictionary *dico in taches) {
            //NSLog(@"Tache dico : %@", dico);
            PBTacheMonteurChantier *tache = [[PBTacheMonteurChantier alloc] initTacheWithInfos:dico];
            [tempTachesArray addObject:tache];
        }
        _tachesArray = [[NSArray alloc] initWithArray:tempTachesArray];
    }
    tempTachesArray = nil;
    taches = nil;
    
    /*----------------------------------------*/
    /* On recupere les TachesMonteurChantier  */
    /*----------------------------------------*/
    NSArray *tachesLR = [jsonObjects objectForKey:keyTachesLRJSON];
    NSMutableArray *tempTachesLRArray = [[NSMutableArray alloc] init];
    
    NSLog(@"TachesLR count : %i", [tachesLR count]);
    if ([tachesLR count]) {
        for (NSDictionary *dico in tachesLR) {
            //NSLog(@"TacheLR dico : %@", dico);
            PBTacheMonteurLeveeReserve *tache = [[PBTacheMonteurLeveeReserve alloc] initTacheWithInfos:dico];
            [tempTachesLRArray addObject:tache];
        }
        _tachesLRArray = [[NSArray alloc] initWithArray:tempTachesLRArray];
    }
    tempTachesLRArray = nil;
    tachesLR = nil;
    
    jsonObjects = nil;
    
    /*----------------------------------------*/
    /* Apres tout recup, save dans UsrDefault */
    /*----------------------------------------*/
    [self saveChantierToUserDefaults];
    
    return true;
}



#pragma mark - NSURLSessionData Delegate Methods

//-------------------------------------------------------
// Lancé une fois a chaque fragment de data
//
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)receivedData
{
    NSLog(@"%s - Iteration : %i, Data length : %i", __func__, _sharedInstance.i, [receivedData length]);
    _sharedInstance.i++;
    
    [_gatherAllData appendData:receivedData];
}

//-------------------------------------------------------
// Une fois la connection terminée, fonction appelée.
// La data est complete
// Permet de savoir également si appareil Connecté
//
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    _sharedInstance.i = 0;
    
    if(error == nil)
    {
        // On s'occuper de la data :
        NSError *error;
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:_gatherAllData options:NSJSONReadingMutableContainers error:&error];
        //NSLog(@"%s : Received JSon : %@", __func__, jsonObjects);
        
        if (error == nil) {
            [[PBChantier sharedChantier] initializeChantierWithJSON:jsonObjects];
        }
        else NSLog(@"%s : erreur conversion JSON", __func__);
        
        // On enleve les donnees temporaires
        _gatherAllData = nil;
        
        // On se deconnecte
        [_session invalidateAndCancel];
        
        // Une fois finit faire cette notification :
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierLoaded" object:self];
        
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.chantierNotLoaded" object:self];
    }
    
    
}

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
	[encoder encodeObject:_idChantier forKey:keyIDChantierForUserDefault];
    [encoder encodeObject:_infosChantier forKey:keyInfosChantierForUserDefault];
    
    [encoder encodeObject:_tachesArray forKey:keyTachesArrayForUserDefault];
    [encoder encodeObject:_tachesLRArray forKey:keyTachesLRArrayForUserDefault];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    //decode properties, other class vars
    _sharedInstance.idChantier = [decoder decodeObjectForKey:keyIDChantierForUserDefault];
    _sharedInstance.infosChantier = [decoder decodeObjectForKey:keyInfosChantierForUserDefault];
    
    _sharedInstance.tachesArray = [decoder decodeObjectForKey:keyTachesArrayForUserDefault];
    _sharedInstance.tachesLRArray = [decoder decodeObjectForKey:keyTachesLRArrayForUserDefault];
    
    return _sharedInstance;
}




@end