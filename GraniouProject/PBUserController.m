//
//  PBLoggedUser.m
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBUserController.h"

// Queue pour fetcher la data
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kBaseURLString          @"http://ahmed-bacha.fr/"
#define kUsersSourceFile        @"json_users.php"
#define kUsersKey               @"users"
#define kUserLoginKey           @"login"
#define kPasswordLoginKey       @"password"
#define kDroitAccesLoginKey     @"droit"
#define kIdChantierLoginKey     @"idChantier"

#define kIsAlreadyLoggedKey     @"alreadyLogged"

@interface PBUserController()

@property (nonatomic, strong) NSDictionary *allLoginsPasswords;

@end


@implementation PBUserController


#pragma mark - Singleton Methods

// Singleton
static PBUserController *_sharedInstance;


+ (void)initialize {
    if (self == [PBUserController class]) {
        _sharedInstance = [[super alloc] init];
        _sharedInstance.hasReceivedLogs = false;
        
        [_sharedInstance downloadUsersFile];
    }
}

+ (PBUserController *)sharedUser {
    return _sharedInstance;
}


#pragma mark - Public Instance Methods

- (BOOL)tryLogin:(NSString *)login password:(NSString *)password{
    if ([[_allLoginsPasswords objectForKey:login] isEqualToString:password]) {
        
        
        return TRUE;
    }
    else return FALSE;
}


#pragma mark - Private Instance Methods

- (void)downloadUsersFile {
    // Run on the background
    dispatch_async(kBgQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kBaseURLString stringByAppendingString:kUsersSourceFile]]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:jsonData waitUntilDone:YES];
    });
}


- (void)fetchedData:(NSData *)jsonData {
    
    if (jsonData) {
        
        NSError *error = nil;
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        // Recuperation de la table "users"
        NSArray *entries = [jsonObjects objectForKey:kUsersKey];
        
        // On rempli le dictionnaire des login/passwords
        NSMutableDictionary *loginsPasswords = [[NSMutableDictionary alloc] initWithCapacity:[entries count]];
        for (NSMutableDictionary *item in entries) {
            [loginsPasswords setObject:[item objectForKey:kPasswordLoginKey] forKey:[item objectForKey:kUserLoginKey]];
        }
        _allLoginsPasswords = [NSDictionary dictionaryWithDictionary:loginsPasswords];
        _sharedInstance.hasReceivedLogs = true;
    }
    
}

@end
