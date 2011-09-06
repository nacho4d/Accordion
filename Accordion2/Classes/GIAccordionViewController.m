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

- (void)initIvars{

	//Initialize here all the ivars that are not views.
	NSString *model= [[UIDevice currentDevice] model];
	NSString *simulator = @"Simulator";
	NSString *path = nil;
	if ([model hasSuffix:simulator]) {
		//Root
		path = @"/";
	} else {
		//Documents
		path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	}
	accordion = [[GIAccordion alloc] initWithPath:path];

	self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	self.title = @"Accordion2";
}

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		[self initIvars];
	}
	return self;
}

- (id) initWithCoder:(NSCoder *)coder{
	self = [super initWithCoder:coder];
	if (self) {
		[self initIvars];
	}
	return self;
}

- (void) loadView{
	[super loadView];
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.toolbarHidden = NO;
}

- (void) viewDidLoad {
	[super viewDidLoad];

	//not implemented yet
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;

	UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sort:)];
	NSArray *items = [[NSArray alloc] initWithObjects:sortButton, nil];
	self.navigationController.toolbarItems = items;
	[items release];

	self.tableView.rowHeight = 66;
	self.tableView.delegate = accordion;
	self.tableView.dataSource = accordion;
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
	[accordion release];
	[super dealloc];
}

- (IBAction)sort:(id)sender{
	NSLog(@"%@ : Not Implemented", NSStringFromSelector(_cmd));
}



@end
