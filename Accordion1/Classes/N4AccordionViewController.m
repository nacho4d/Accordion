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
#import "N4PromptAlertView.h"


@implementation N4AccordionViewController

@synthesize detailViewController;
@synthesize datasourceManager, sortDescriptors;
@synthesize tableView;
@synthesize navigationBar;

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
#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = 44;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	[self createTestData];
	
	sortDescriptors = [N4FileAccordionDatasourceManager defaultSortDescriptors];
	datasourceManager = [[N4FileAccordionDatasourceManager alloc] initWithRootPath:[self applicationDocumentsDirectory]
																   sortDescriptors:sortDescriptors];
	datasourceManager.delegate = self;
	
	
	UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Accordion"];
	navigationBar.items = [NSArray arrayWithObject:item];
	[item release]; 

	UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																				   target:self 
																				   action:@selector(changeToEditMode:)];      
	navigationBar.topItem.leftBarButtonItem = leftBarButton;
	[leftBarButton release];
	
	UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					target:self 
																					action:@selector(showCreateNewFileMenu:)];       
	navigationBar.topItem.rightBarButtonItem = rightBarButton;
	[rightBarButton release];
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	return YES;
}

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

#pragma mark - 
#pragma mark N4FileAccordionDatasourceManagerDelegate methods

- (void) fileAccordionDatasourceManager:(N4FileAccordionDatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView insertRowsAtIndexPaths:indexPaths 
						  withRowAnimation: UITableViewRowAnimationLeft];
	if ([indexPaths count] == 1) { //ok here? 
		[self.tableView selectRowAtIndexPath:[indexPaths objectAtIndex:0] 
									animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}
- (void) fileAccordionDatasourceManager:(N4FileAccordionDatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths{
	[self.tableView deleteRowsAtIndexPaths:indexPaths 
						  withRowAnimation:UITableViewRowAnimationLeft];
}

- (void) fileAccordionDatasourceManager:(N4FileAccordionDatasourceManager *) manager didCreateSuccessfullyFile:(N4File *) file{
	
}
- (void) fileAccordionDatasourceManager:(N4FileAccordionDatasourceManager *) manager didFailOnCreationofFile:(N4File *)file error:(NSError *)error{
	
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {

	return [datasourceManager.mergedRootBranch count];
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyCellIdentifier";
	N4AccordionViewCell *cell = (N4AccordionViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[N4AccordionViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
		cell.indentationWidth = 30.0;
    }
    
	N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	cell.cellType = (file.isDirectory)? N4TableViewCellTypeDirectory : N4TableViewCellTypeFile;
	cell.directoryAccessoryImageView.image = (file.isDirectory)? [UIImage imageNamed:@"TriangleSmall.png"] : nil;
	cell.imageView.image = [file image];
	cell.textLabel.text = [file name]; 
	cell.detailTextLabel.text = [file name];

	return cell;
}


/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	N4File * file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	if (!file.isDirectory || file.isEmptyDirectory) return YES;
	else return NO;
}
*/

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		N4File * file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
		[detailViewController removeFile:file];
		
		[datasourceManager deleteFileAtIndex:indexPath.row];
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		[datasourceManager createFileAtIndex:indexPath.row withName:[NSString stringWithFormat:@"%@", [NSDate date]]];
		[aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }   
}


// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}




// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
	//
//    return YES;
//}




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
		
		//[self.tableView reloadData]; //do not update datasource or tableview here		
		//rows will be inserted/deleted using datasourceManager delegate methods
		
	}
	else{
		detailViewController.detailItem = [NSString stringWithFormat:@"%@", file.name];
		detailViewController.backgroundImageVIew.image = [file imageBig];
		[detailViewController addFile:file];
		
		
	}
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
	return file.level; 
}





#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
	return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{

	
	if (popoverController == sorterPopoverController) {
		//do not do [self.tableview reloadData] here. it is done by FileSorterViewControllerDelegate
		[sorterPopoverController release];
		sorterPopoverController = nil;
	}
	else if (popoverController == fileCreatorPopoverController) {
		[fileCreatorPopoverController release];
		fileCreatorPopoverController = nil;
	}

}
#pragma mark -
#pragma mark N4FileSorterViewControllerDelegate

- (void) fileSorterViewController:(N4FileSorterViewController *)filerSorterViewController 
			  didUpdateDataSource:(NSMutableArray*)datasource{
	[datasourceManager sort];
	[self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
	
}


#pragma mark -
#pragma mark Button actions

- (IBAction) showSortingMenu:(id)sender{
	if (!sorterPopoverController.popoverVisible) {
		
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		
		N4FileSorterViewController *vc = [[N4FileSorterViewController alloc] initWithStyle:UITableViewStylePlain];
		[vc setDescriptorsDatasource:sortDescriptors];
		[vc setSorterDelegate:self];
		
		sorterPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
		[vc release];
		
		int w = 240, h = 44;
		[sorterPopoverController setPopoverContentSize:CGSizeMake(w, h*5)];
		[sorterPopoverController presentPopoverFromBarButtonItem:sender 
										permittedArrowDirections:UIPopoverArrowDirectionAny
														animated:YES];
		[sorterPopoverController setDelegate:self];
	}
	
}
- (void) changeToEditMode:(id)sender{
	UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																				   target:self 
																				   action:@selector(changeToNormalMode:)];      
	navigationBar.topItem.leftBarButtonItem = leftBarButton;
	[leftBarButton release];
	[self.tableView setEditing:YES animated:YES];
	
}
- (void) changeToNormalMode:(id)sender{
	UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																				   target:self 
																				   action:@selector(changeToEditMode:)];      
	navigationBar.topItem.leftBarButtonItem = leftBarButton;
	[leftBarButton release];
	[self.tableView setEditing:NO animated:YES];
	
}
- (void) showCreateNewFileMenu:(id)sender{
	
	if (!fileCreatorPopoverController.popoverVisible) {
		
		//[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
		
		int w = 240, h = 44;
		UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h*4)];
		UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, w, h)];
		[button1 addTarget:self action:@selector(createDirectoryAlert) forControlEvents:UIControlEventTouchUpInside];
		[button1 setTitle:@"New Directory ... " forState:UIControlStateNormal];
		[container addSubview:button1];
		[button1 release];
		
		UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 88, w, h)];
		[button2 addTarget:self action:@selector(createFileAlert) forControlEvents:UIControlEventTouchUpInside];
		[button2 setTitle:@"New File ... " forState:UIControlStateNormal];
		[container addSubview:button2];
		[button2 release];
		
		UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 132, w, h)];
		[button3 addTarget:self action:@selector(duplicateFileAlert) forControlEvents:UIControlEventTouchUpInside];
		[button3 setTitle:@"Duplicate File ... " forState:UIControlStateNormal];
		[container addSubview:button3];
		NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
		if (!selectedIndexPath ||
			((N4File *)[datasourceManager.mergedRootBranch objectAtIndex:selectedIndexPath.row]).isDirectory) [button3 setEnabled:NO];
		[button3 release];
		
		UIViewController *vc = [[UIViewController alloc] init];
		vc.view = container;
		[container release];
		
		fileCreatorPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
		[vc release];
		
		
		[fileCreatorPopoverController setPopoverContentSize:CGSizeMake(w, h*4)];
		[fileCreatorPopoverController presentPopoverFromBarButtonItem:sender 
										permittedArrowDirections:UIPopoverArrowDirectionAny
														animated:YES];
		[fileCreatorPopoverController setDelegate:self];
	}

}

#pragma mark -
- (void) createDirectoryAlert {
	
	
	
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSString *message;
	if (!selectedIndexPath)
		message = @"New directory will be created at the top level";
	else{
		N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:selectedIndexPath.row];
		if (file.isDirectory) 
			message = [NSString stringWithFormat:@"New directory will be created inside of %@", [file name]];
		else
			message = [NSString stringWithFormat:@"New directory will be created at same level of %@", [file name]];
	}
					   
	createDirectoryAlert = [[UIAlertView alloc] initWithTitle:@"New directory" 
												 message:message
												delegate:self 
									   cancelButtonTitle:@"Cancel" 
									   otherButtonTitles:@"OK", nil];
	[createDirectoryAlert show];
	[createDirectoryAlert release];
}
- (void) createFileAlert{
	

	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSString *message;
	if (!selectedIndexPath)
		message = @"New directory will be created at the top level";
	else{
		N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:selectedIndexPath.row];
		if (file.isDirectory) 
			message = [NSString stringWithFormat:@"New directory will be created inside of %@", [file name]];
		else
			message = [NSString stringWithFormat:@"New directory will be created at same level of %@", [file name]];
	}
	
	createFileAlert = [[UIAlertView alloc] initWithTitle:@"New directory" 
												 message:message
												delegate:self 
									   cancelButtonTitle:@"Cancel" 
									   otherButtonTitles:@"OK", nil];
	[createFileAlert show];
	[createFileAlert release];
}
- (void) duplicateFileAlert{
	
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSString *message;
	if (!selectedIndexPath)
		message = @"File will be duplicated at the top level";
	else{
		N4File *file = [datasourceManager.mergedRootBranch objectAtIndex:selectedIndexPath.row];
		if (file.isDirectory) 
			message = [NSString stringWithFormat:@"File will be duplicated inside of %@", [file name]];
		else
			message = [NSString stringWithFormat:@"File will be duplicated at same level of %@", [file name]];
	}
	
	duplicateFileAlert = [[UIAlertView alloc] initWithTitle:@"New directory" 
												 message:message
												delegate:self 
									   cancelButtonTitle:@"Cancel" 
									   otherButtonTitles:@"OK", nil];
	[duplicateFileAlert show];
	[duplicateFileAlert release];
}


- (void) createDirectory{
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSInteger selectedIndex = (!selectedIndexPath) ? -1 : selectedIndexPath.row;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[datasourceManager createDirectoryAtIndex:selectedIndex withName:[NSString stringWithFormat:@"Directory%i", (arc4random()%1000)]];
	
}
- (void) createFile{
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSInteger selectedIndex = (!selectedIndexPath) ? -1 : selectedIndexPath.row;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[datasourceManager createFileAtIndex:selectedIndex withName:[NSString stringWithFormat:@"Directory%i", (arc4random()%1000)]];

}
- (void) duplicateFile{
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	NSInteger selectedIndex = (!selectedIndexPath) ? -1 : selectedIndexPath.row;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
	[datasourceManager duplicateFileAtIndex:selectedIndex withName:[NSString stringWithFormat:@"Duplicate%i", (arc4random()%1000)]];

}

- (void) willPresentAlertView:(UIAlertView *)alertView{
	[fileCreatorPopoverController dismissPopoverAnimated:YES];
	[fileCreatorPopoverController release];
	fileCreatorPopoverController = nil;
	
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index{
	if (index != 0) {
		if (alertView == createFileAlert) [self createFile];
		else if (alertView == createDirectoryAlert) [self createDirectory];
		else if (alertView == duplicateFileAlert) [self duplicateFile];
	}
}
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //[((UIAlertView *)alertView).textField resignFirstResponder];
    //[((UIAlertView *)alertView).textField removeFromSuperview];  
    //[((UIAlertView *)alertView).textField release];  
}


@end
