//
//  PBListeDocumentsTableTableViewController.m
//  GraniouProject
//
//  Created by Philippe Tumata on 20/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//
// Queue pour fetcher la data


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kBaseURLString              @"http://ahmed-bacha.fr/"
#define kUsersSourceFile            @"json_pdfs.php"
#define kFichiers                   @"fichiers"
#define kName                       @"name"
#define kLink                       @"link"



#import "PBListeDocumentsTableTableViewController.h"
#import "PBShowPDFViewController.h"

@interface PBListeDocumentsTableTableViewController ()

@property (nonatomic, strong) NSArray *listeDocuments;

@end

@implementation PBListeDocumentsTableTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self downloadDocuments];
    
    
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
    return _listeDocuments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentCell" forIndexPath:indexPath];
    
    // Update cell content
    NSDictionary *document = [_listeDocuments objectAtIndex:indexPath.row];
    cell.textLabel.text = [document objectForKey:kName];
    
    
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
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    PBShowPDFViewController *vc = [segue destinationViewController];
    vc.document = [_listeDocuments objectAtIndex:indexPath.row];

}




#pragma mark - Networking

- (void)downloadDocuments {
    
    // Run on the background
    dispatch_async(kBgQueue, ^{
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[kBaseURLString stringByAppendingString:kUsersSourceFile]]];
        [self performSelectorOnMainThread:@selector(parseFetchedData:) withObject:jsonData waitUntilDone:YES];
    });
}


- (void)parseFetchedData:(NSData *)jsonData {
    
    NSMutableArray *listeTemporaire = [[NSMutableArray alloc] init];
    if (jsonData) {
        
        NSError *error = nil;
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
        NSLog(@"%@", jsonObjects);
            
        // Recuperation de la table "fichiers"
        listeTemporaire = [jsonObjects objectForKey:kFichiers];
    }
    
    
    for (NSMutableDictionary *dico in listeTemporaire) {
        NSMutableString *lien = [NSMutableString stringWithString:[dico objectForKey:kLink]];
        if ([lien replaceOccurrencesOfString:@" " withString:@"%20" options:0 range:NSMakeRange(0, [lien length])]) {
            [dico setObject:lien forKey:kLink];
        }
        
    }
    
    _listeDocuments = listeTemporaire;
    [self.tableView reloadData];
}


@end
