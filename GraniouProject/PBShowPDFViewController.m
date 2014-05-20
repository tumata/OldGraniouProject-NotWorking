//
//  PBShowPDFViewController.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 20/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "PBShowPDFViewController.h"

#define kLink @"link"
#define kName @"name"
#define kSize @"size"

/*-------------------------------------
 * les éléments ne sont pas supprimés
 * une fois sauvegardés....
 * et ne sont plus accessibles....
 *-----------------------------------*/


@interface PBShowPDFViewController ()

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;


@end

@implementation PBShowPDFViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self downloadPDF];
}

- (void)viewDidDisappear:(BOOL)animated {
//    NSString *path = [[self applicationDocumentsDirectory].path
//                      stringByAppendingPathComponent:[_document objectForKey:kName]];
//    NSError *error;
//    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//    NSLog(@"%@", path);
//    NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    [super viewDidDisappear:animated];
}


- (void) downloadPDF
{
    NSString *path = [[self applicationDocumentsDirectory].path
                      stringByAppendingPathComponent:[_document objectForKey:kName]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"%s : Existe deja", __func__);
    }
    else {
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_document objectForKey:kLink]]];
        bool good = [pdfData writeToFile:path atomically:YES];
        NSLog(@"%s : Good : %i", __func__, good);
    }
    
}

#pragma mark -
#pragma mark Actions
- (IBAction)previewDocument:(id)sender {
    NSURL *URL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory].path
                                         stringByAppendingPathComponent:[_document objectForKey:kName]]];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

- (IBAction)openDocument:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSURL *URL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory].path
                                         stringByAppendingPathComponent:[_document objectForKey:kName]]];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Present Open In Menu
        [self.documentInteractionController presentOpenInMenuFromRect:[button frame] inView:self.view animated:YES];
    }
}

#pragma mark -
#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}


/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}
@end
