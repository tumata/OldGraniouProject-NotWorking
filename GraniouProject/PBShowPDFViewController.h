//
//  PBShowPDFViewController.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 20/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBShowPDFViewController : UIViewController <UIDocumentInteractionControllerDelegate>

@property (nonatomic, weak) NSDictionary *document;

@end
