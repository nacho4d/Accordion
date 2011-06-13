//
//  N4FileSorterViewController.m
//  MandalaChart
//
//  Created by Guillermo Ignacio Enriquez Gutierrez on 8/24/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import "N4FileSorterViewController.h"


@interface N4FileSorterViewController ()
@property (nonatomic, retain) UITableView * tableView; 
@end

@implementation N4FileSorterViewController
@synthesize descriptorsDatasource, sorterDelegate;
@synthesize tableView;
#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super init])) {
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,240, 176 + 44)];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[v setAutoresizesSubviews:YES];
		self.view = v;
		[v release];
		
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
		[self.view addSubview:iv];
		[iv release];	
		
		tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44,240, 176) style:style];
		[tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[self.view addSubview:tableView];
		[tableView release];
		
		[self.tableView setBounces:NO];
		[self.tableView setAllowsSelectionDuringEditing:YES];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView setEditing:YES animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [descriptorsDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
	NSSortDescriptor *desc = [descriptorsDatasource objectAtIndex:indexPath.row];
	
	if ([[desc key] isEqualToString:@"type"])
		cell.textLabel.text = @"Type";
	else if ([[desc key] isEqualToString:@"name"]) 
		cell.textLabel.text = @"Name";
	else if ([[desc key] isEqualToString:@"creationDate"])
		cell.textLabel.text = @"Creation Date";
	else
		cell.textLabel.text = @"Modification Date";
	
	if([desc ascending])
		cell.imageView.image = [UIImage imageNamed:@"ascending.png"];
	else
		cell.imageView.image = [UIImage imageNamed:@"descending.png"];
	
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	[descriptorsDatasource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
	[self.sorterDelegate fileSorterViewController:self didUpdateDataSource:descriptorsDatasource];
}

#pragma mark -
#pragma mark Table view delegate

- (void) cellChangedAtIndexPath:(NSIndexPath *)indexPath{
	NSSortDescriptor *desc = [descriptorsDatasource objectAtIndex:indexPath.row];
	NSSortDescriptor *descInverted = [desc reversedSortDescriptor];
	[descriptorsDatasource replaceObjectAtIndex:indexPath.row withObject:descInverted];
	[self.tableView reloadData];
	[self.sorterDelegate fileSorterViewController:self didUpdateDataSource:descriptorsDatasource];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self performSelector:@selector(cellChangedAtIndexPath:) withObject:indexPath afterDelay:0.4];
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
	[descriptorsDatasource release];
}


@end

