//
//  GIAccordionViewController.h
//  Accordion2
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/20/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import <UIKit/UIKit.h>

@class GIAccordion;

@interface GIAccordionViewController : UITableViewController {
	GIAccordion *accordion;
}

- (IBAction)sort:(id)sender;

@end
