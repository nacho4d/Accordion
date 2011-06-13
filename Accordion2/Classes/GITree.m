//
//  GITree.m
//  dictionary
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/9/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import "GITree.h"
#import "GITreeNode.h"


@implementation GITree

@synthesize sortDescriptors = _sortDescriptors;

- (id) initWithPath:(NSString *)baseDirectoryPath{
	if ((self = [super init])) {
		_baseDir = [[GITreeNode alloc] initWithName:[baseDirectoryPath lastPathComponent] 
										 parentPath:[baseDirectoryPath stringByDeletingLastPathComponent]];
		_sortDescriptors = nil;
		_sortedNodes = nil;
	}
	return self;
}
#pragma mark -
#pragma mark helpers

//recursively composites array, array is assumed to be empty
- (void) _compositeSorteNodes:(NSMutableArray *)array 
				   baseDirNode:(GITreeNode *)dirNode{
	NSArray *childrenNodes = dirNode.children;
	for (GITreeNode *node in childrenNodes) {
		[array addObject:node];
		if (node.directoryIsExpanded) {
			[self _compositeSorteNodes:array baseDirNode:node];
		}
	}
	
}

//recursively sorts arrays
- (void) _sortChildrenNodesOfNode:(GITreeNode *)dirNode{
	NSMutableArray *childrenNodes = dirNode.children;
	[childrenNodes sortUsingDescriptors:_sortDescriptors];
	
	for (GITreeNode *node in childrenNodes) {
		if (node.directoryIsExpanded) {
			[self _sortChildrenNodesOfNode:node];
		}
	}
}

//recursively collapse nodes, returns number of items collapsed
- (int) _collapseNode:(GITreeNode *)node{
	int res = 0;
	if (node.directoryIsExpanded) {
		NSArray *children = node.children;
		res = children.count;
		for (GITreeNode *child in children) {
			res += [self _collapseNode:child];
		}
	}
	return res;
}

//recursively add children and all its expanded children to array at position index
- (int) _insertChildren:(NSArray *)children inArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
	
	[array replaceObjectsInRange:NSMakeRange(index, 0) withObjectsFromArray:children];
	int res = 0;
	int i=0;
	for (GITreeNode *child in children) {
		if (child.directoryIsExpanded) {
			i += [self _insertChildren:child.children inArray:array atIndex:index+i+1];
			res += child.children.count;
		}
		i++;
	}
	res += children.count;
	return res;
	
}

#pragma mark -
#pragma mark public methods

-(NSArray *)nodes{
	if (!_sortedNodes) {
		_sortedNodes = [[NSMutableArray alloc] init];
		[self _sortChildrenNodesOfNode:_baseDir];
		[self _compositeSorteNodes:_sortedNodes baseDirNode:_baseDir];		
	}
	return (NSArray *)_sortedNodes;
}

- (NSRange) expandNodeAtIndex:(NSUInteger)index{
	
	GITreeNode *node = (GITreeNode *)[self.nodes objectAtIndex:index];
	[self _sortChildrenNodesOfNode:node];
	
	[node expand];
	int collapsedNum = [self _insertChildren:node.children inArray:_sortedNodes atIndex:index+1];
	
		
	NSRange expandRange = NSMakeRange(index+1, collapsedNum);
	return expandRange;
}

- (NSRange) collapseNodeAtIndex:(NSUInteger)index{
	
	GITreeNode *node = (GITreeNode *)[_sortedNodes objectAtIndex:index];
	int collapsedNum = [self _collapseNode:node];
	
	NSRange collapseRange = NSMakeRange(index+1, collapsedNum);
	[_sortedNodes removeObjectsInRange:collapseRange];
	[node collapse];
	return collapseRange;
	
}


#pragma mark -
#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)aTableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
	GITreeNode *node = [self.nodes objectAtIndex:indexPath.row];
	return node.depth; 
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	return self.nodes.count;;
}

//default implementation, nothing fancy
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

	//below is what it has to be passed to a cell but UITableViewCell is too basic.
	GITreeNode *node = (GITreeNode *)[self.nodes objectAtIndex:indexPath.row];	
	cell.indentationLevel = node.depth;
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %d", node.isDirectory?@"D":@"F",
						   node.filename, indexPath.row];
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
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
 forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row 
 to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath 
 toIndexPath:(NSIndexPath *)toIndexPath {
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
	
	
	GITreeNode *node = (GITreeNode *)[self.nodes objectAtIndex:indexPath.row];
	//NSLog(@"touching...%@", [node description]);
	if (node.isDirectory) {
		if (node.directoryIsExpanded) {
			
			NSRange collapsedRange = [self collapseNodeAtIndex:indexPath.row];
			NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
			for (int i = 0; i<collapsedRange.length; i++) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:collapsedRange.location+i inSection:0]];
			}
			[aTableView deleteRowsAtIndexPaths:indexPaths 
								  withRowAnimation:UITableViewRowAnimationLeft];
			[indexPaths release];
			
		}else {
			
			NSRange expandedRange = [self expandNodeAtIndex:indexPath.row];
			NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
			for (int i = 0; i<expandedRange.length; i++) {
				[indexPaths addObject:[NSIndexPath indexPathForRow:expandedRange.location+i inSection:0]];
			}
			[aTableView insertRowsAtIndexPaths:indexPaths 
								  withRowAnimation:UITableViewRowAnimationLeft];
			[indexPaths release];
		}
		
	}

}

/*
- (NSRange) deleteNodeAtIndex:(NSUInteger) index{
	
}

- (void)tableView:(UITableView *)aTableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		GITreeNode *node = [self.nodes objectAtIndex:indexPath.row];
		NSRange collapsedRange = [self collapseNodeAtIndex:indexPath.row];
		[self
		NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
		for (int i = 0; i<collapsedRange.length; i++) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:collapsedRange.location+i inSection:0]];
		}
		[aTableView deleteRowsAtIndexPaths:indexPaths 
						  withRowAnimation:UITableViewRowAnimationLeft];
		[indexPaths release];
		
		GIFile * file = [datasourceManager.mergedRootBranch objectAtIndex:indexPath.row];
		[detailViewController removeFile:file];
		
		[datasourceManager deleteFileAtIndex:indexPath.row];
		[aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
	}   
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		
		[datasourceManager createFileAtIndex:indexPath.row withName:[NSString stringWithFormat:@"%@", [NSDate date]]];
		[aTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
		
	}   
}
	
 */


@end
