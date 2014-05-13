//
//  LoadDataController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 09/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//


//URL ou envoyer la data
#define destinationUrl @"http://ahmed-bacha.fr/json_data.php"



#import "PBLoadDataController.h"
#import "PBUserSyncController.h"

@interface PBLoadDataController ()

@end

@implementation PBLoadDataController{
    NSTimer *timer;
}

@synthesize progressBar;
@synthesize loadDataView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
    progressBar.progress = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getAllDataForActiveUser];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)moreProgress{
    progressBar.progress += 0.1;
    
    if (progressBar.progress == 1){
        [timer invalidate];
        [self performSegueWithIdentifier:@"dataLoaded" sender:self];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (bool)getAllDataForActiveUser
{
    ///////////////////////////////////////////////////////////////////////////////
    ////////////  Conversion de l'ID_Chantier en NSData  //////////////////////////
    ///////////////////////////////////////////////////////////////////////////////

    NSLog(@"%@", [[PBUserSyncController sharedUser] idChantier]);
    
    NSString    *data = [[PBUserSyncController sharedUser] idChantier];
    NSData      *postData = [data dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    
    ///////////////////////////////////////////////////////////////////////////////
    ////////////////////Envoi de la sortie au serveur /////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////
    
    // Creation de l'URL
    NSMutableURLRequest *postRequest = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:destinationUrl]
                                        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                        timeoutInterval:10];
    
    [postRequest setHTTPMethod:@"POST"];
    
    // Si "POST" alors la data se place ici
    [postRequest setHTTPBody:postData];
    
    
    ///////////////////////////////////////////////////////////////////////////////
    ////////// Lancement de la requete et recuperation des donnees ////////////////
    ///////////////////////////////////////////////////////////////////////////////
    
    NSError     *error;
    NSURLResponse *response;
    NSData *getReply = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:nil];
    
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:getReply options:NSJSONReadingMutableContainers error:&error];
    

    NSLog(@"%@", jsonObjects);
    
    return true;
}


@end
