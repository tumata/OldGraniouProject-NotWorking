//
//  PBLoggedUser.h
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBUserSyncController : NSObject

@property (nonatomic, strong, readonly) NSString  *login;
@property (nonatomic, strong, readonly) NSString  *password;
@property (nonatomic, strong, readonly) NSString  *droitAcces;
@property (nonatomic, strong, readonly) NSString  *idChantier;

@property (nonatomic, readonly) BOOL  hasReceivedLogs;
@property (nonatomic, readonly) BOOL  isLogged;


+ (PBUserSyncController *)sharedUser;

- (BOOL)tryLogin:(NSString *)login password:(NSString *)password;


@end