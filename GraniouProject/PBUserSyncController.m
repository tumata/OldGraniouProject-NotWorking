//
//  PBLoggedUser.m
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBUserSyncController.h"
#import "PBChantier.h"

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Utilisé comme clef dans NSUserDefault
#define kUserDefaultNameKey        @"UtilisateurSaved"

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString              @"http://ahmed-bacha.fr/"
#define kUsersSourceFile            @"json_users.php"
#define kUsersKey                   @"users"
#define kLoginKey                   @"login"
#define kPasswordLoginKey           @"password"
#define kDroitAccesLoginKey         @"droit"
#define kIdChantierLoginKey         @"idChantier"

#define kDroitAccesValueResponsable @"Responsable"
#define kDroitAccesValueConducteur  @"Conducteur"
#define kDroitAccesValueEquipe      @"Equipe"

#define kIsAlreadyLoggedKey         @"alreadyLogged"

@interface PBUserSyncController()
@property (nonatomic, strong) NSArray       *allUsers;
@property (nonatomic, strong) NSDictionary  *allLoginsPasswords;

@property (readwrite) NSString  *login;
@property (readwrite) NSString  *password;
@property (readwrite) NSString  *droitAcces;
@property (readwrite) NSString  *idChantier;

@property (readwrite) BOOL      hasDownloadedLogs;
@property (readwrite) BOOL      isNowLoggedFromLoginScreen;
@property (readwrite) BOOL      wasLoggedBeforeLoginScreen;

@property (readwrite, strong)   NSTimer *timer;


@end


@implementation PBUserSyncController


#pragma mark - Singleton Methods

// Singleton
static PBUserSyncController *_sharedInstance;


+ (void)initialize {
    if (self == [PBUserSyncController class]) {
        _sharedInstance = [[super alloc] init];
        _sharedInstance.hasDownloadedLogs = false;
        _sharedInstance.isNowLoggedFromLoginScreen = false;
        _sharedInstance.wasLoggedBeforeLoginScreen = false;
        
        
        if (![_sharedInstance isUserAlreadyLoggedWhenLaunchingApplication]) {
            //---------------------------------------------------------------------
            // Ici il n'est donc pas encore loggé au moment du lancement de l'appli
            
            // On telecharge la liste des users depuis le serveur
            [_sharedInstance downloadUsersFile];
        }
        else {
            //------------------------------------------------
            // Ici il est loggé au moment ou l'appli se lance
            
            // On charge le chantier depuis UserDefault
            //[[PBChantier sharedChantier] getChantierFromUserDefaults];
            
            // On charge le user depuis UsersDefault
            [_sharedInstance loadUserFromUserDefaults];
        
        }
    }
}

+ (PBUserSyncController *)sharedUser {
    return _sharedInstance;
}


#pragma mark - Public Instance Methods

- (BOOL)tryLogin:(NSString *)login password:(NSString *)password{
    if ([[_allLoginsPasswords objectForKey:login] isEqualToString:password]) {
        
        // Bon login/psw donc on charge les donnees depuis _allUsers
        for (NSDictionary *user in _allUsers) {
            if ([[user objectForKey:kLoginKey] isEqualToString:login]) {
                _login = [user objectForKey:kLoginKey];
                _password = [user objectForKey:kPasswordLoginKey];
                _droitAcces = [user objectForKey:kDroitAccesLoginKey];
                _idChantier = [user objectForKey:kIdChantierLoginKey];
                
                NSLog(@"%s : %@, %@, %@, %@", __PRETTY_FUNCTION__, _login, _password, _droitAcces, _idChantier);
                [self saveUserToUserDefaults];
            }
        }
        _allUsers = nil;
        _allLoginsPasswords = nil;
        
        _isNowLoggedFromLoginScreen = true;
        return TRUE;
    }
    else {
        _isNowLoggedFromLoginScreen = false;
        return FALSE;
    }
}

// Test si l'utilisateur est un conducteur
- (BOOL)isConducteur {
    if ([_droitAcces isEqualToString:kDroitAccesValueConducteur]) return true;
    else return false;
}


- (BOOL)isMonteur {
    if ([_droitAcces isEqualToString:kDroitAccesValueEquipe]) return true;
    else return false;
}

// Efface les informations de UserDefaults, tout a été uploadé
- (void)removeUserFromUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultNameKey];
    }
}

// Scenario lorsque l'application se terminate
- (void)applicationWillTerminateScenario {
    if ([self isUserLogged] && ![[PBChantier sharedChantier] isEmpty]) {
        
        // Sauvegarde le User
        [self saveUserToUserDefaults];
        NSLog(@"%s : userSavedToDefaults", __func__);
        
        // Sauvegarder les donnees chantier
        [[PBChantier sharedChantier] saveChantierToUserDefaults];
    }
    else {
        // Bug, on enleve le user 
        [self removeUserFromUserDefaults];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Remise a zero des donnees
- (void)reinitializeUserAndChantierToZero {
    _sharedInstance.hasDownloadedLogs = false;
    _sharedInstance.isNowLoggedFromLoginScreen = false;
    _sharedInstance.wasLoggedBeforeLoginScreen = false;
    
    _sharedInstance.login = nil;
    _sharedInstance.password = nil;
    _sharedInstance.idChantier = nil;
    _sharedInstance.droitAcces = nil;
    _sharedInstance.hasDownloadedLogs = false;
    _sharedInstance.isNowLoggedFromLoginScreen = false;
    _sharedInstance.wasLoggedBeforeLoginScreen = false;
    
    [[PBChantier sharedChantier] reinitializeToZero];
    
    [_sharedInstance downloadUsersFile];
    
}



#pragma mark - Private Instance Methods

// Test si l'utilisateur est loggé
- (BOOL)isUserLogged {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey]) {
        return true;
    }
    else {
        return false;
    }
}

// Test si l'utilisateur est deja loggé au moment du lancement de l'application
- (BOOL)isUserAlreadyLoggedWhenLaunchingApplication {
    
    // Test si UserDefaults pour User présent
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey]) {
        _wasLoggedBeforeLoginScreen = true;
        return TRUE;
    }
    else {
        _wasLoggedBeforeLoginScreen = false;
        return FALSE;
    }
}



// Recupere les informations du user loggé depuis UserDefaults
- (void)loadUserFromUserDefaults {
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey];
    _login = [user objectForKey:kLoginKey];
    _password = [user objectForKey:kPasswordLoginKey];
    _droitAcces = [user objectForKey:kDroitAccesLoginKey];
    _idChantier = [user objectForKey:kIdChantierLoginKey];
}

// Sauvegarde l'utilisateur dans le UserDefaults
- (void)saveUserToUserDefaults {
    NSMutableDictionary *user = [[NSMutableDictionary alloc] init];
    
    [user setObject:_login forKey:kLoginKey];
    [user setObject:_password forKey:kPasswordLoginKey];
    [user setObject:_droitAcces forKey:kDroitAccesLoginKey];
    [user setObject:_idChantier forKey:kIdChantierLoginKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:kUserDefaultNameKey];
    
    user = nil;
    
}

// Recuperation des users
- (void)downloadUsersFile {
    
    // Run on the background
    dispatch_async(kBgQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kBaseURLString stringByAppendingString:kUsersSourceFile]]];
        [self performSelectorOnMainThread:@selector(parseFetchedData:) withObject:jsonData waitUntilDone:YES];
    });
}


- (void)parseFetchedData:(NSData *)jsonData {
    
    if (jsonData) {
        if (!_wasLoggedBeforeLoginScreen) {
            NSError *error = nil;
            
            id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"%@", jsonObjects);
            
            // Recuperation de la table "users"
            NSArray *entries = [jsonObjects objectForKey:kUsersKey];
            
            // On rempli le dictionnaire des login/passwords
            NSMutableDictionary *loginsPasswords = [[NSMutableDictionary alloc] initWithCapacity:[entries count]];
            for (NSMutableDictionary *item in entries) {
                NSString *equipe = [item objectForKey:kDroitAccesLoginKey];
                if (![equipe isEqualToString:kDroitAccesValueResponsable]) {
                    [loginsPasswords setObject:[item objectForKey:kPasswordLoginKey] forKey:[item objectForKey:kLoginKey]];
                }
            }
            
            _allUsers = entries;
            _allLoginsPasswords = loginsPasswords;
        }
        else {
            NSLog(@"LoggedBefore et Internet");
        }
        [self fetchedDataHasBeenParsedSuccessfuly:TRUE];
        
    }
    else {
        _allLoginsPasswords = nil;
        [self fetchedDataHasBeenParsedSuccessfuly:FALSE];
    }
    
}

- (void)fetchedDataHasBeenParsedSuccessfuly:(BOOL)successfuly {
    if (successfuly) {
        _hasDownloadedLogs = true;
    }
    else {
        _hasDownloadedLogs = false;
        if (_wasLoggedBeforeLoginScreen) {
            NSLog(@"LoggedBefore mais pas internet");
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pb.notLoggedNoInternet" object:self];
        }
    }
}

@end
