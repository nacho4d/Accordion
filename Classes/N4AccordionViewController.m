//
//  RootViewController.m
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "N4AccordionViewController.h"
#import "DetailViewController.h"

#import "N4File.h"
#import "N4AccordionViewCell.h"


@implementation N4AccordionViewController

@synthesize detailViewController;
@synthesize datasourceManager, sortDescriptors;

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) createTestData{
	
	NSLog(@"Creating some sample Data...");
	
	NSFileManager *fm = [NSFileManager defaultManager];
	//[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Misc"] attributes:nil];
	//[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Misc2"] attributes:nil];
	
	//[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"data.xml"]  contents:nil attributes:nil];
	//[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"dictionary.plist"] contents:nil attributes:nil];
	
	[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics"] attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/mum.jpg"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/たまちゃん.png"]  contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/Me.tiff"]  contents:nil attributes:nil];
	[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer"] attributes:nil];
	[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/裸"] attributes:nil];
		[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/裸/裸.jpg"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/beach.jpg"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/SanFrancisco.jpg"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/Tokyo.jpg"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Pics/LastSummer/KeioUniversity.jpg"] contents:nil attributes:nil];
	
	[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Movies"] attributes:nil]; 
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Movies/GoneWithTheWind.avi"]  contents:nil attributes:nil];
	[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Movies/Empty"] attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Movies/NARUTO-ナルト-疾風伝.mp4"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Movies/BeautifullMind.mpeg"] contents:nil attributes:nil];
	
	//[fm createDirectoryAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Documents"] attributes:nil];
	
	//[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Thesis.pdf"] contents:nil attributes:nil];
	//[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"paper.tex"] contents:nil attributes:nil];
	[fm createFileAtPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"ラブレーター.txt"] contents:nil attributes:nil];
	
	NSLog(@"Creating some sample Data... Finished");
		

}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 56;
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	[self createTestData];
	
	sortDescriptors = [N4FileAccordionDatasourceManager defaultSortDescriptors];
	datasourceManager = [[N4FileAccordionDatasourceManager alloc] initWithRootPath:[self applicationDocumentsDirectory]];
	datasourceManager.sortDescriptors = sortDescriptors;
	datasourceManager.delegate = self;
	
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - 
#pragma mark N4FileAccordionDatasourceManagerDelegate methods

- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView insertRowsAtIndexPaths:indexPaths 
						  withRowAnimation: UITableViewRowAnimationLeft];
}
- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView deleteRowsAtIndexPaths:indexPaths 
						  withRowAnimation:UITableViewRowAnimationLeft];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

	return [datasourceManager.mergedRootBranch count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCellIdentifier";
	N4AccordionViewCell *cell = (N4AccordionViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[N4AccordionViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.indentationWidth = 30.0;
    }
    
	// Configure the cell.
	N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	cell.cellType = (file.isDirectory)? N4TableViewCellTypeDirectory : N4TableViewCellTypeFile;
	cell.directoryAccessoryImageView.image = (file.isDirectory)? [UIImage imageNamed:@"TriangleSmall.png"] : nil;
	cell.imageView.image = [file image];
	cell.textLabel.text = [file name]; 
	cell.detailTextLabel.text = [file name];

	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	if (file.isDirectory) {
		if (file.isExpanded){
			N4AccordionViewCell *curCell = (N4AccordionViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
			curCell.expanded = NO;
			[datasourceManager collapseBranchAtIndex:indexPath.row];
			file.expanded = NO;
		}
		else{
			N4AccordionViewCell *curCell = (N4AccordionViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
			curCell.expanded = YES;
			
			[datasourceManager expandBranchAtIndex:indexPath.row];
			file.expanded = YES;
		}
				
	}

	
	detailViewController.detailItem = [NSString stringWithFormat:@"%@", file.name];
	detailViewController.backgroundImageVIew.image = [file imageBig];
	
	
	//[self.tableView reloadData]; //rows will be inserted/deleted using datasourceManager delegate methods
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	return file.level; 
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    // self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
	[datasourceManager release];
	[sortDescriptors release];
    [super dealloc];
}


@end

