//
//  LoadDataController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 09/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//


////////////////////////////////////////////////////////////////////////
//
// Ici il va falloir :
//
//      1. Si connection internet : recuperer la liste des identifiants
//
////////////////////////////////////////////////////////////////////////

#import "PBLoadDataController.h"

@interface PBLoadDataController ()

@end

@implementation PBLoadDataController

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



- (void)moreProgress{
    progressBar.progress += 0.1;
    
    if (progressBar.progress == 1){
        [timer invalidate];
        [self performSegueWithIdentifier:@"dataLoaded" sender:self];
    }
    
}

- (void)viewDidLoad
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
    progressBar.progress = 0;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
