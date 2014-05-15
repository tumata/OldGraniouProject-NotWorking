//
//  PBPresentationChantierViewController.m
//  GraniouProject
//
//  Created by Philippe Tumata on 15/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBPresentationChantierViewController.h"
#import "PBChantier.h"

@interface PBPresentationChantierViewController ()

@property (readwrite) NSDictionary *infosChantier;

@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar1;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar2;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar3;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar4;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar5;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar6;

@end

@implementation PBPresentationChantierViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeAllUIItemsFromPBChantier];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeAllUIItemsFromPBChantier {
    PBChantier *chantier = [PBChantier sharedChantier];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[[chantier getKeyThenValueNomChantier] objectAtIndex:1] attributes:underlineAttribute];
    
    [_labelTitre setAttributedText:title];
    _labelTitre.textColor = [UIColor blueColor];
    _labelTitre.font = [UIFont fontWithName:@"American Typewriter" size:24];
    
    NSArray *itemsArray = [[NSArray alloc] initWithObjects:_toolbar1, _toolbar2, _toolbar3, _toolbar4, _toolbar5, _toolbar6, nil];
    NSArray *infosArray = [chantier getTheSixInfosKeyThenValue];
    
    // Pour chaque barItem :
    for (int i = 0; i < itemsArray.count; i++) {
        int j = 0;
        
        // Pour chaque barButton :
        for (UIBarButtonItem *item in [[itemsArray objectAtIndex:i] items]) {
            
            // Si c'est le bon bouton, on set le texte
            if (j == 2) {
                if ([[infosArray objectAtIndex:i] count] >= 2) {
                    [item setTitle:[[infosArray objectAtIndex:i] objectAtIndex:1]];
                    [item setTintColor:[UIColor blackColor]];
                }
            }
            j++;
        }
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

#pragma mark - IB Actions

- (IBAction)actionDeconnexion:(id)sender {
    
    
}


@end
