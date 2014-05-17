//
//  MonteurConducteurView.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 10/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBMenuPrincipalViewController.h"
#import "PBUserSyncController.h"

@interface PBMenuPrincipalViewController ()
@property (weak, nonatomic) IBOutlet UIButton *boutonMonteur;
@property (weak, nonatomic) IBOutlet UIButton *boutonConducteur;

@end

@implementation PBMenuPrincipalViewController

@synthesize buttonConducteur, buttonMonteur, vueCentrale;

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[PBUserSyncController sharedUser] isMonteur]) {
        [_boutonConducteur setUserInteractionEnabled:false];
        [_boutonConducteur setHidden:true];
    }
    if ([[PBUserSyncController sharedUser] isConducteur]) {
        [_boutonMonteur setUserInteractionEnabled:false];
        [_boutonMonteur setHidden:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
