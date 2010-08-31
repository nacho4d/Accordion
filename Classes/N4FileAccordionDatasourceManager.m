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
		[branch sortUsingDescriptors:self.sortDescriptors];
	}
}

- (void) _mergeBranches{
	
	[self.mergedRootBranch setArray:[_unmergedBranches objectForKey:rootDirectory]];
	NSMutableArray *branchKeys = [[_unmergedBranches allKeys] mutableCopy];
	NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"level" ascending:YES];
	[branchKeys sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
	
	NSInteger index = NSNotFound;
	for (N4File *branchKey in branchKeys) {
		if (branchKey == rootDirectory) continue;
		NSMutableArray *unmergedBranch = [_unmergedBranches objectForKey:branchKey];
		index = [self.mergedRootBranch indexOfObject:branchKey];
		[self.mergedRootBranch replaceObjectsInRange:NSMakeRange(index+1, 0) withObjectsFromArray:unmergedBranch];
	}
	[sortDesc release];
	[branchKeys release];
	
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

- (id) initWithRootPath:(NSString *)path sortDescriptors:(NSMutableArray *)sortDescs{
	
	if (self = [super init]) {
		
		self.sortDescriptors = sortDescs;
			
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
		NSString *parentPath = [path stringByDeletingLastPathComponent];
		rootDirectory = [[N4File alloc] initWithName:[path lastPathComponent] parentDirectory:parentPath];
		//rootDirectory.isDirectory = YES;
		[rootDirectory setLevel:-1];
		[rootDirectory setExpanded:YES];
		
		[_unmergedBranches setObject:filesAtRootLevel forKey:rootDirectory];
		[filesAtRootLevel release];
		
		_mergedRootBranch = [[NSMutableArray alloc] init];
		
		[self _sortBranches];
		[self _mergeBranches];
		
 	}
	return self;
}
- (void) dealloc{
	[_sortDescriptors release];
	[_mergedRootBranch release];
	[_unmergedBranches release];
	delegate = nil;
	[super dealloc];
}
#pragma mark -

- (void) sort{
	[self _sortBranches];
	[self _mergeBranches];
}

- (void) reloadAllBranches{
	//TODO:
}
#pragma mark -

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
		[newBranch sortUsingDescriptors:self.sortDescriptors];
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

#pragma mark -



- (void) moveFileFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
	 
	//if file:
	//get all indexes for root expanded branches.
	//find a position between two indexes, and place 
	//replace the phisical object.
	//update datasoruce
	
	//if directory:
	//get all files:
}

- (void) deleteFileAtIndex:(NSInteger)index{
	N4File *file = [self.mergedRootBranch objectAtIndex:index];
		
	//delete file from disk:
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	[fm removeItemAtPath:[file fullName] error:&error];
	if (error)	NSLog(@"Error %s :%@", _cmd, [error localizedDescription]);
	
	//delete file from memory
	//delete it from corresponding unmerged branch - get its containerDirectory
	N4File *containerDirectory = nil;
	NSInteger offsetToContainerDirectory;
	for (int i = index; i > 0 ; --i) {
		N4File *tempFile = [self.mergedRootBranch objectAtIndex:i];
		if (tempFile.level < file.level) {
			containerDirectory = tempFile;
			offsetToContainerDirectory = index - i - 1;
			break;
		}
	}
	
	if (!containerDirectory) {
		containerDirectory = rootDirectory;
		offsetToContainerDirectory = index;
	}

	//I should refactor this, many ifs should not be needed.
	NSMutableArray *branch = [_unmergedBranches objectForKey:containerDirectory];
	if (containerDirectory != rootDirectory) {
		[branch removeObjectAtIndex:offsetToContainerDirectory];
	}
	
	//delete it from merged branch if needed
	if (branch != self.mergedRootBranch) 
		[self.mergedRootBranch removeObjectAtIndex:index];
}
- (void) createFileAtIndex:(NSInteger)index withName:(NSString *)fileName{
		
	//get directory to insert in, and expand it if needed
	N4File *referenceFile = [self.mergedRootBranch objectAtIndex:index];
	N4File *containerDirectory = nil;
	NSInteger offsetToContainerDirectory;
	if (referenceFile.isDirectory) {
		containerDirectory = referenceFile;
		offsetToContainerDirectory = 0;
	}else {
		for (int i = index; i > 0 ; --i) {
			N4File *file = [self.mergedRootBranch objectAtIndex:i];
			if (file.level < referenceFile.level) {
				containerDirectory = file;
				offsetToContainerDirectory = index - i;
				break;
			}
		}
		if (!containerDirectory) {
			containerDirectory = rootDirectory;
			offsetToContainerDirectory = index;
		}
		//containerDirectory = [self directoryContainingFileAtIndex:index offset:&offsetToContainerDirectory];
	}
	if (!containerDirectory.expanded) {
		NSInteger expandIndex = [self.mergedRootBranch indexOfObject:containerDirectory];
		[self expandBranchAtIndex:expandIndex];
	}
	
	//create file on disk
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm createFileAtPath:[[containerDirectory fullName] stringByAppendingFormat:fileName] 
				contents:nil 
			  attributes:nil];
	
	//create file in memory
	N4File *newFile = [[N4File alloc] initWithName:fileName parentDirectory:[containerDirectory fullName]];
	[newFile setLevel:containerDirectory.level + 1];

	//insert it  into the corresponding branch and merged it manually
	NSMutableArray *branch = [_unmergedBranches objectForKey:containerDirectory];
	[branch insertObject:newFile atIndex:offsetToContainerDirectory];
	[self.mergedRootBranch insertObject:newFile atIndex:index];
	[newFile release];
	
}
- (void) duplicateFileAtIndex:(NSInteger)index withName:(NSString *)fileName{
	[self createFileAtIndex:index withName:fileName];
	//duplicate data of object at index and rewrite it to disk. 
}

#pragma mark -





@end
