//
//  RootViewController.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "N4FileAccordionDatasourceManager.h"
#import "N4FileSorterViewController.h"

@class DetailViewController;
@class N4FileAccordionDatasourceManager;

@interface N4AccordionViewController : UIViewController <N4FileAccordionDatasourceManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, N4FilerSorterViewControllerDelegate>{
	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UITableView *tableView;
	
    DetailViewController *detailViewController;
	N4FileAccordionDatasourceManager *datasourceManager;
	NSMutableArray *sortDescriptors;
	UIPopoverController *sorterPopoverController;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) N4FileAccordionDatasourceManager *datasourceManager;
@property (nonatomic, retain) NSMutableArray *sortDescriptors;

- (IBAction) showSortingMenu:(id)sender;

@end
