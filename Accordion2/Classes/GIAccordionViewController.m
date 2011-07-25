//
//  GIAccordionViewController.m
//  Accordion2
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/20/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import "GIAccordionViewController.h"
#import "GIAccordion.h"


@implementation GIAccordionViewController

// The designated initializer.  Override if you create the controller programmatically and
//want to perform customization that is not appropriate for viewDidLoad.
/*
 - (void) initilize
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization.
	}
	return self;
}
- (id) initWithCoder:...{
 
 }
*/

- (void) loadView{
	
	//Create UI elements programatically

	
	//crate top toolbar
	toolbarTop = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320, 44)];
	[toolbarTop setAutoresizingMask:UIViewAutoresizingFlexibleWidth | 
	 UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
	 UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(changeEditMode:)];
	NSArray *items = [[NSArray alloc] initWithObjects:editButton, nil];
	[toolbarTop setItems:items];
	[items release];
	
	//create bottom toolbar
	toolbarBottom = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 556,320, 44)];
	[toolbarBottom setAutoresizingMask:UIViewAutoresizingFlexibleWidth | 
	 UIViewAutoresizingFlexibleTopMargin |
	  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(sort:)];
	
	items = [[NSArray alloc] initWithObjects:sortButton, nil];
	[toolbarBottom setItems:items];
	[items release];
	
	//create table view
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 512) style:UITableViewStylePlain];
	[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
	 UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	[tableView setAllowsSelectionDuringEditing:YES];
	//create view
	UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
	[container setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
	  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
	  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
	[container addSubview:tableView];
	[container addSubview:toolbarTop];
	[container addSubview:toolbarBottom];

	self.view = container;
	[container release];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	//for simulator/Debug
	NSString *path = @"/";
	
	//for the device
	//NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	if (!accordion) {
		accordion = [[GIAccordion alloc] initWithPath:path]; //this should be done in _initialize
	}

	[tableView setDelegate:accordion];
	[tableView setDataSource:accordion];
	[tableView setRowHeight:66];
	
	[self.view  setBackgroundColor:[UIColor grayColor]];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[tableView release];
	[toolbarTop release];
	[toolbarBottom release];
	[super dealloc];
}

- (IBAction)changeEditMode:(id)sender{
	[tableView setEditing:!tableView.editing animated:YES];
}
- (IBAction)sort:(id)sender{
	NSLog(@"%@ : Not Implemented", NSStringFromSelector(_cmd));
}



@end
