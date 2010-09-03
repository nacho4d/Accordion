//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//

#import "N4PromptAlertView.h"

@implementation N4PromptAlertView
@synthesize textField;
@synthesize enteredText;

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasHidden:)
												 name:UIKeyboardDidHideNotification object:nil];
}

- (void) unregisterKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	NSString *msg = [NSString stringWithFormat:@"%@\n\n", message];
    if (self = [super initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 90.0, 260.0, 25.0)]; //when text is two lines: 90
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
		theTextField.delegate = self;
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
		CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
		[self setTransform:translate];
		
		[self registerForKeyboardNotifications];
		
		
        
    }
    return self;
}
- (void)show
{
    [super show];
	[textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.4];
}
- (NSString *)enteredText
{
    return textField.text;
}
- (void)dealloc
{
	[textField removeFromSuperview];
    [textField release];
    [super dealloc];
}
- (void) layoutSubviews{
	[super layoutSubviews];
	NSLog(@"%s", _cmd);
	//if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
	//	NSLog(@"is landscape, moving +130"); //- is down + is up
	//	CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, +130.0); 
	//	[self setTransform:translate];
	//}
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Resize the window view (which is the root view of the window)
    CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
    windowFrame.size.height -= keyboardSize.height;
	[[UIApplication sharedApplication] keyWindow].frame = windowFrame;
	
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWasHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
	
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
    // Reset the height of the window view to its original value
	CGRect windowFrame = [[UIApplication sharedApplication] keyWindow].frame;
    windowFrame.size.height += keyboardSize.height;
	[[UIApplication sharedApplication] keyWindow].frame = windowFrame;
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self unregisterKeyboardNotifications];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	[theTextField resignFirstResponder];
	[self dismissWithClickedButtonIndex:0 animated:YES];
	return YES;
}
@end