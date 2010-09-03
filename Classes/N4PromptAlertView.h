//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//
#import <Foundation/Foundation.h>

@interface N4PromptAlertView  : UIAlertView <UITextFieldDelegate>
{
    UITextField *textField;
}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
	  okButtonTitle:(NSString *)okButtonTitle;
@end
