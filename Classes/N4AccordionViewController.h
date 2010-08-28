//
//  RootViewController.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "N4FileAccordionDatasourceManager.h"

@class DetailViewController;
@class N4FileAccordionDatasourceManager;

@interface N4AccordionViewController : UITableViewController <N4FileAccordionDatasourceManagerDelegate>{
    DetailViewController *detailViewController;
	N4FileAccordionDatasourceManager *datasourceManager;
	NSMutableArray *sortDescriptors;
}


@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) N4FileAccordionDatasourceManager *datasourceManager;
@property (nonatomic, retain) NSMutableArray *sortDescriptors;

@end
