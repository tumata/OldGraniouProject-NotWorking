//
//  PBLoggedUser.m
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBUserSyncController.h"

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

// Utilisé comme clef dans NSUserDefault
#define kUserDefaultNameKey        @"UtilisateurSaved"

// Liens et clefs pour recuperer depuis le serveur
#define kBaseURLString          @"http://ahmed-bacha.fr/"
#define kUsersSourceFile        @"json_users.php"
#define kUsersKey               @"users"
#define kLoginKey               @"login"
#define kPasswordLoginKey       @"password"
#define kDroitAccesLoginKey     @"droit"
#define kIdChantierLoginKey     @"idChantier"

#define kIsAlreadyLoggedKey     @"alreadyLogged"

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
            [_sharedInstance downloadUsersFile];
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


#pragma mark - Private Instance Methods

// Test si l'utilisateur est deja loggé au moment du lancement de l'application
- (BOOL)isUserAlreadyLoggedWhenLaunchingApplication {
    
    // Test si UserDefaults pour User présent
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultNameKey]) {
        _wasLoggedBeforeLoginScreen = true;
        [self loadUserFromUserDefaults];
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
    _hasDownloadedLogs = true;
}




- (void)downloadUsersFile {
    
    // Run on the background
    dispatch_async(kBgQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kBaseURLString stringByAppendingString:kUsersSourceFile]]];
        [self performSelectorOnMainThread:@selector(parseFetchedData:) withObject:jsonData waitUntilDone:YES];
    });
}


- (void)parseFetchedData:(NSData *)jsonData {
    
    if (jsonData) {
        
        NSError *error = nil;
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        // Recuperation de la table "users"
        NSArray *entries = [jsonObjects objectForKey:kUsersKey];
        
        // On rempli le dictionnaire des login/passwords
        NSMutableDictionary *loginsPasswords = [[NSMutableDictionary alloc] initWithCapacity:[entries count]];
        for (NSMutableDictionary *item in entries) {
            [loginsPasswords setObject:[item objectForKey:kPasswordLoginKey] forKey:[item objectForKey:kLoginKey]];
        }
        
        _allUsers = entries;
        _allLoginsPasswords = loginsPasswords;
        
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
    else _hasDownloadedLogs = false;
}

@end
