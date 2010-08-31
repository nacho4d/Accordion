//
//  N4FileAccordionDatasourceManager.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <UIKit/UIKit.h>

@class N4FileAccordionDatasourceManager;
@protocol N4FileAccordionDatasourceManagerDelegate <NSObject>
@required
- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths;
- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths;

@end

@class N4File;
@interface N4FileAccordionDatasourceManager : NSObject {
	
	NSMutableArray *_sortDescriptors;
	NSMutableArray *_mergedRootBranch;
	NSMutableDictionary *_unmergedBranches;
	id<N4FileAccordionDatasourceManagerDelegate> delegate;
	N4File *rootDirectory;
}

@property (nonatomic, retain) NSMutableArray *sortDescriptors;
@property (nonatomic, retain, readonly) NSMutableArray * mergedRootBranch;
@property (nonatomic, assign) id<N4FileAccordionDatasourceManagerDelegate> delegate;

+ (NSMutableArray *) defaultSortDescriptors;
- (id) initWithRootPath:(NSString *)path sortDescriptors:(NSMutableArray *)sortDescs;
- (void) sort;

- (void) expandBranchAtIndex:(NSInteger)index;
- (void) collapseBranchAtIndex:(NSInteger)index;

- (void) moveFileFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (void) deleteFileAtIndex:(NSInteger)index;
- (void) createFileAtIndex:(NSInteger)index withName:(NSString *)fileName;
- (void) duplicateFileAtIndex:(NSInteger)index withName:(NSString *)fileName;




@end
