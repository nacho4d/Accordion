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
@optional
- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didInsertRowsAtIndexPaths:(NSArray *)indexPaths;
- (void) fileTreeDatasourceManager:(N4FileAccordionDatasourceManager *) manager didRemoveRowsAtIndexPaths:(NSArray *)indexPaths;
@end

@interface N4FileAccordionDatasourceManager : NSObject {
	
	NSMutableArray *_sortDescriptors;
	NSMutableArray *_mergedRootBranch;
	NSMutableDictionary *_unmergedBranches;
	id<N4FileAccordionDatasourceManagerDelegate> delegate;

}

@property (nonatomic, retain) NSMutableArray *sortDescriptors;
@property (nonatomic, retain, readonly) NSMutableArray * mergedRootBranch;
@property (nonatomic, assign) id<N4FileAccordionDatasourceManagerDelegate> delegate;

+ (NSMutableArray *) defaultSortDescriptors;
- (id) initWithRootPath:(NSString *)path;
- (void) sort;
- (void) expandBranchAtIndex:(NSInteger)index;
- (void) collapseBranchAtIndex:(NSInteger)index;
- (void) moveFileFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;





@end
