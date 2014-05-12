//
//  LoadDataController.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 09/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBLoginViewController.h"

@interface PBLoadDataController : UIViewController
{
    NSTimer *timer;
}

@property (retain, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UIView *loadDataView;



@end
