//
//  PBTacheMonteurChantierTableViewController.m
//  GraniouProject
//
//  Created by Philippe Tumata on 17/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBTacheMonteurChantierTableViewController.h"
#import "PBTacheMonteurChantier.h"
#import "PBDetailedTacheMonteurChantierViewController.h"
#import "PBChantier.h"

@interface PBTacheMonteurChantierTableViewController ()

@property (weak, nonatomic) NSArray *taches;

@end

@implementation PBTacheMonteurChantierTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _taches = [[PBChantier sharedChantier] tachesArray];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _taches.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tacheCell" forIndexPath:indexPath];
    
    // Update cell content
    PBTacheMonteurChantier *tache = [_taches objectAtIndex:indexPath.row];
    cell.textLabel.text = tache.titre;
    
    
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailedTache"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PBTacheMonteurChantier *tache = [_taches objectAtIndex:indexPath.row];

        PBDetailedTacheMonteurChantierViewController *vc =  [segue destinationViewController];
        [vc setTache:tache];
    }

}


@end
