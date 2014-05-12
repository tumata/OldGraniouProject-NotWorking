//
//  PBLoggedUser.h
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBLoggedUser : NSObject

@property (nonatomic, strong) NSDictionary *loginsPasswords;
@property (nonatomic, strong) NSString  *login;
@property (nonatomic, strong) NSString  *password;
@property (nonatomic, strong) NSString  *droitAcces;
@property (nonatomic, strong) NSString  *idChantier;
@property (nonatomic) BOOL  hasReceivedLogs;


+ (PBLoggedUser *)sharedUser;



@end