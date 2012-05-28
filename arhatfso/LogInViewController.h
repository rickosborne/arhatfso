//
//  LogInViewController.h
//  arhatfso
//
//  Created by rosborne on 5/26/12.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
{
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	IBOutlet UIButton *continueButton;
	IBOutlet UIProgressView *progress;
	IBOutlet UILabel *status;
}

@end
