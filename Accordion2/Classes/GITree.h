//
//  GITree.h
//  dictionary
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/9/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//

#import <Foundation/Foundation.h>


@class GITreeNode;

//Controller of GITreeNodes and conforms to UITableViewDelegate and Datasource protocols
@interface GITree : NSObject <UITableViewDelegate, UITableViewDataSource>{
	
	GITreeNode *_baseDir;
	NSMutableArray *_sortDescriptors;
	NSMutableArray *_sortedNodes;

}

@property (nonatomic, retain) NSMutableArray *sortDescriptors;
@property (nonatomic, retain, readonly) NSArray *nodes; //hides mutability

- (id) initWithPath:(NSString *)baseDirectoryPath;

- (NSRange) expandNodeAtIndex:(NSUInteger)index;
- (NSRange) collapseNodeAtIndex:(NSUInteger)index;


@end
