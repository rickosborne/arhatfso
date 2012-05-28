//
//  LogInViewController.m
//  arhatfso
//
//  Created by rosborne on 5/26/12.
//

#import "LogInViewController.h"
#import "FSOService.h"

@implementation LogInViewController

- (void)disableControl:(UIControl *)control
{
	control.alpha = 0.1f;
	control.enabled = NO;
	control.userInteractionEnabled = NO;
}

- (void)enableControl:(UIControl *)control
{
	control.alpha = 1.0f;
	control.enabled = YES;
	control.userInteractionEnabled = YES;
}

- (void)setWorkingState
{
	progress.hidden = NO;
	[self.view endEditing:YES];
	[self disableControl:usernameField];
	[self disableControl:passwordField];
	[self disableControl:continueButton];	
}

- (void)setEntryState
{
	status.text = @"";
	progress.hidden = YES;
	passwordField.text = @"";
	[self disableControl:continueButton];
	[self enableControl:usernameField];
	[self enableControl:passwordField];
	[self viewDidAppear:NO];
}

- (void)fsoUserDidLoadMainProfile
{
	NSLog(@"fsoUserDidLoadMainProfile");	
	status.text = @"Loading photo ...";
	progress.progress = 0.5f;
}

- (void)fsoUserDidLoadPhoto
{
	NSLog(@"fsoUserDidLoadMainProfile");	
	status.text = @"Loading contact info ...";
	progress.progress = 0.7f;
}

- (void)fsoUserDidLoadContactInfo
{
	NSLog(@"fsoUserDidLoadMainProfile");	
	status.text = @"Reticulating splines ...";
	progress.progress = 0.9f;
}

- (void)fsoUserDidLogIn
{
	NSLog(@"fsoUserDidLogIn");	
	status.text = @"Success!";
	progress.progress = 1.0f;
}

- (void)fsoUserDidAuthenticate
{
	NSLog(@"fsoUserDidAuthenticate");
	status.text = @"Loading profile ...";
	progress.progress = 0.3f;
}

- (void)fsoUserFailedToLogIn:(NSString *)errorMessage
{
	// [self setEntryState];
	NSLog(@"fsoUserFailedToLogIn:%@", errorMessage);
}
	 
- (void)viewDidAppear:(BOOL)animated
{
	// save the user a tap by focusing the appropriate text field
	if (usernameField.text.length > 0)
	{
		[passwordField becomeFirstResponder];
	}
	else
	{
		[usernameField becomeFirstResponder];
	}
}

- (IBAction)onFieldChange:(id)sender
{
	 if ((usernameField.text.length > 0) && (passwordField.text.length > 0))
	 {
		 [self enableControl:continueButton];
	 }
	else
	{
		[self disableControl:continueButton];
	}
}

- (IBAction)onContinue:(id)sender
{
	if ((usernameField.text.length > 0) && (passwordField.text.length > 0))
	{
		status.text = @"Authenticating ...";
		progress.progress = 0.1f;
		[self setWorkingState];
		[[FSOService defaultService] logInUser:usernameField.text withPassword:passwordField.text withListener:self];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setEntryState];
}

- (void)viewDidUnload
{
	continueButton = nil;
	progress = nil;
	status = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
