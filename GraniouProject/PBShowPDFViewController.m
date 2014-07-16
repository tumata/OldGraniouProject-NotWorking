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
}


#pragma mark -
#pragma mark Actions
- (IBAction)previewDocument:(id)sender {
    NSURL *URL = [self getUrlPath];
    
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
    NSURL *URL = [self getUrlPath];
    
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

- (NSURL *)getUrlPath {
    return [NSURL fileURLWithPath:[self getStringPath]];
}

- (NSString *)getStringPath {
    return [[self applicationDocumentsDirectory].path
     stringByAppendingPathComponent:_document];
}
@end
