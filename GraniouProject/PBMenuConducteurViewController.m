//
//  MenuConducteur.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 13/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBMenuConducteurViewController.h"

@interface PBMenuConducteurViewController ()

@end

@implementation PBMenuConducteurViewController

@synthesize buttonPreRecettes, buttonListePhotos;

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
