//
//  LoginViewController.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 08/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBLoginViewController : UIViewController <UITextFieldDelegate>
{
    UITextField *textFieldID;
    UITextField *textFieldPSW;
}

- (void)registerForKeyboardNotifications;

- (void)keyBoardSlide: (CGFloat) deltaY;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)tryConnection:(id)sender;


- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
