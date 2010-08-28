//
//  N4FileAccordionDatasourceManager.m
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import "N4FileAccordionDatasourceManager.h"
#import "N4File.h"

@interface N4FileAccordionDatasourceManager ()

@property (nonatomic, retain, readwrite) NSMutableArray * mergedRootBranch;
@end


@implementation N4FileAccordionDatasourceManager

@synthesize sortDescriptors = _sortDescriptors;
@synthesize mergedRootBranch = _mergedRootBranch;
@synthesize delegate;

- (void) _sortBranches{
	for (NSMutableArray *branch in [_unmergedBranches allValues]){
		[branch sortUsingDescriptors:_sortDescriptors];
	}
}
- (void) _mergeBranches{
	
	self.mergedRootBranch = [_unmergedBranches objectForKey:@"ROOT"];
	NSInteger index = NSNotFound;
	NSEnumerator *enumerator = [_unmergedBranches keyEnumerator];
	id key;	
	
	while ((key = [enumerator nextObject])) {
		if (key == @"ROOT") continue;
		NSMutableArray *unmergedBranch = [_unmergedBranches objectForKey:key];
		index = [self.mergedRootBranch indexOfObject:key];
		if (index != NSNotFound) 
			[self.mergedRootBranch replaceObjectsInRange:NSMakeRange(index+1, 0) withObjectsFromArray:unmergedBranch];
		
	}
}

- (void) _sortBranchAtIndex:(NSIndexPath *)indexPath{
	
}

+ (NSMutableArray *) defaultSortDescriptors{
	
	NSSortDescriptor * sortDescType = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES]; // Folders come first
	NSSortDescriptor * sortDescName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];  // Z ~ A
	NSSortDescriptor * sortDescCreationDate = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
	NSSortDescriptor * sortDescModificationDate = [[NSSortDescriptor alloc] initWithKey:@"modificationDate" ascending:YES];
	
	NSMutableArray *descs = [NSMutableArray arrayWithObjects:
							 sortDescCreationDate,
							 sortDescType, 
							 sortDescName,  
							 sortDescModificationDate, nil];
	
	[sortDescType release];
	[sortDescName release];
	[sortDescCreationDate release];
	[sortDescModificationDate release];
	
	return descs;
}

- (id) initWithRootPath:(NSString *)path{
	
	if (self = [super init]) {
			
		_unmergedBranches = [[NSMutableDictionary alloc] init];
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSArray *fileNames = [fileMgr directoryContentsAtPath:path];
		NSMutableArray *filesAtRootLevel = [[NSMutableArray alloc] init];
		for (NSString * fileName in fileNames) 
		{
			N4File *aFile = [[N4File alloc] initWithName:fileName parentDirectory:path];
			[aFile setLevel:0];
			[filesAtRootLevel addObject:aFile];
			[aFile release];
		}
		[_unmergedBranches setObject:filesAtRootLevel forKey:@"ROOT"];
		[filesAtRootLevel release];
		
		_mergedRootBranch = [[NSMutableArray alloc] init];
		
		[self _sortBranches];
		[self _mergeBranches];
		
 	}
	return self;
}
- (void) sort{
	[self _sortBranches];
	[self _mergeBranches];
}

- (void) reloadAllBranches{
	//TODO:
}

- (void) expandBranchAtIndex:(NSInteger)index{
	N4File *directoryFile = [self.mergedRootBranch objectAtIndex:index];
	if (directoryFile.isDirectory) {

		//Make Branch:
		NSFileManager *fileMgr = [NSFileManager defaultManager];
		NSArray *fileNames = [fileMgr directoryContentsAtPath:directoryFile.fullName];
		
		NSMutableArray *newBranch = [[NSMutableArray alloc] init];
		for (NSString * fileName in fileNames) 
		{
			N4File *aFile = [[N4File alloc] initWithName:fileName parentDirectory:directoryFile.fullName];
			[aFile setLevel:directoryFile.level + 1];
			[newBranch addObject:aFile];
			[aFile release];
		}
		
		//sort and add it unmerged branches
		[newBranch sortUsingDescriptors:_sortDescriptors];
		[_unmergedBranches setObject:newBranch forKey:directoryFile];
		[newBranch release];
		
		//merge it:
		[_mergedRootBranch replaceObjectsInRange:NSMakeRange(index+1, 0) withObjectsFromArray:newBranch];
		[directoryFile setExpanded:YES];
		
		//call delegate
		if ([delegate respondsToSelector:@selector(fileTreeDatasourceManager:didInsertRowsAtIndexPaths:)]) {
			NSMutableArray *paths = [NSMutableArray array]; 
			for (int i = 0; i < [newBranch count]; i++) {
				[paths addObject:[NSIndexPath indexPathForRow:(index + 1 + i) inSection:0]];
			}
			[delegate fileTreeDatasourceManager:self didInsertRowsAtIndexPaths:paths];
		}
		
		

		
	}
}

- (void) collapseBranchAtIndex:(NSInteger)index;{
	N4File *directoryFile = [self.mergedRootBranch objectAtIndex:index];
	if (directoryFile.isDirectory) {
		
		NSMutableArray *branchToCollapse = [_unmergedBranches objectForKey:directoryFile];
		
		//recursively collapse expanded branches
		for (int i = 0; i < [branchToCollapse count]; i++) {
			N4File *file = [branchToCollapse objectAtIndex:i];
			if (file.isDirectory && file.isExpanded) {
				[self collapseBranchAtIndex:index + i + 1]; //+1 is super important!!
			}
		}
		
		NSRange range = NSMakeRange(index+1, [branchToCollapse count]);
		[self.mergedRootBranch removeObjectsInRange:range];
		[_unmergedBranches removeObjectForKey:directoryFile];
		[directoryFile setExpanded:NO];
		
		//call delegate
		if ([delegate respondsToSelector:@selector(fileTreeDatasourceManager:didRemoveRowsAtIndexPaths:)]) {
			NSMutableArray *paths = [NSMutableArray array]; 
			for (int i = 0; i < range.length; i++) {
				[paths addObject:[NSIndexPath indexPathForRow:(index + 1 + i) inSection:0]];
			}
			[delegate fileTreeDatasourceManager:self didRemoveRowsAtIndexPaths:paths];
		}
		
	}
	
}



- (void) moveFileFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
	//TODO: BRING SUPPORT FOR RE-ARRANGEMENT
	//if file:
	//get all indexes for root expanded branches.
	//find a position between two indexes, and place 
	//replace the phisical object.
	//update datasoruce
	
	//if directory:
	//get all files:
}

- (void) dealloc{
	[_sortDescriptors release];
	[_mergedRootBranch release];
	[_unmergedBranches release];
	delegate = nil;
	[super dealloc];
}



@end
