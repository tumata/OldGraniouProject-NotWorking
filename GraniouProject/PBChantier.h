//
//  PBChantier.h
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTacheMonteurChantier.h"

@interface PBChantier : NSObject <NSURLSessionDataDelegate, NSCoding>

@property (nonatomic) NSString           *idChantier;


@property (nonatomic, strong, readonly) NSDictionary    *infosChantier;
@property (nonatomic, strong) NSArray                   *tachesArray;




+ (PBChantier *)sharedChantier;


- (void)uploadChantierToServerThenDownload;
- (void)uploadChantierToServer;
- (void)loadChantierFromServer;

- (BOOL)saveChantierToUserDefaults;
- (BOOL)getChantierFromUserDefaults;
- (BOOL)removeChantierFromUserDefaults;

- (void)reinitializeToZero;


- (NSArray *)getTheSixInfosKeyThenValue;

- (NSArray *)getKeyThenValueNomChantier;
- (NSArray *)getKeyThenValueAmenageur;
- (NSArray *)getKeyThenValuePartenaire;
- (NSArray *)getKeyThenValueAdresse;
- (NSArray *)getKeyThenValueDate;
- (NSArray *)getKeyThenValueCodeSite;
- (NSArray *)getKeyThenValueBrin;
- (NSArray *)getKeyThenValuePhase;


@end
