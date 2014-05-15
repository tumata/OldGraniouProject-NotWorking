//
//  PBChantier.h
//  GraniouProject
//
//  Created by Philippe Tumata on 08/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTache.h"

@interface PBChantier : NSObject <NSURLSessionDataDelegate>


@property (nonatomic, strong, readonly) NSDictionary *infosChantier;

@property (nonatomic) NSInteger                 *_idChantier;
@property (nonatomic, weak) NSMutableArray    *_tachesArray;




+ (PBChantier *)sharedChantier;


- (void)uploadChantierToServerThenDownload;
- (void)uploadChantierToServer;
- (void)loadChantierFromServer;

- (BOOL)saveChantierToUserDefaults;
- (BOOL)getChantierFromUserDefaults;



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
