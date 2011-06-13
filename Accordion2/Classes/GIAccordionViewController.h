//
//  GIAccordionViewController.h
//  Accordion2
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/20/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GIAccordion;

@interface GIAccordionViewController : UIViewController {
	IBOutlet UITableView *tableView;
	IBOutlet UIToolbar *toolbarTop;
	IBOutlet UIToolbar *toolbarBottom;
	GIAccordion *accordion;
	
}

- (IBAction)changeEditMode:(id)sender;
- (IBAction)sort:(id)sender;

@end
