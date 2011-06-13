//
//  GITreeNode.h
//  dictionary
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/9/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import <Foundation/Foundation.h>


@interface GITreeNode : NSObject {
@protected
	NSString *_name;
	
	NSString *_parentPath;
	GITreeNode *_parent;
	NSMutableArray *_children;
	
	NSDictionary *_properties;
	
	NSInteger _depth;
	BOOL _expanded;
}

/// inits a node with a parent node
- (id) initWithName:(NSString *)name parent:(GITreeNode *)parent;

/// inits a node without a parent, only its path
- (id) initWithName:(NSString *)name parentPath:(NSString *)parentPath;

/// accessor for _name
@property (nonatomic, retain, readonly) NSString *filename;

/// lazy property. If directory then it is not nil
@property (nonatomic, retain, readonly) NSMutableArray *children;

/// accessor for _parent
@property (nonatomic, assign, readonly) GITreeNode *parent; 

/// calculates the extension from _name
@property (nonatomic, assign, readonly) NSString *fileExtension;

/// calculates absolute by recursively accesing its parent or parentPath
@property (nonatomic, assign, readonly) NSString *absolutePath;

/// tells if node represents a directory
@property (nonatomic, readonly) BOOL isDirectory;

/// lazy property, accesor of creation date. cashed the date
@property (nonatomic, assign, readonly) NSDate *creationDate;

/// accesor of modification date, always read date from disk
@property (nonatomic, assign, readwrite) NSDate *modificationDate;

/// lazy property. depth of node
@property (nonatomic, readonly) NSInteger depth;

@property (nonatomic, readonly) BOOL directoryIsExpanded;


/*
	Since each node represents a file on disk.
	There are 3 kind of operations:
	1: Phisical: When operation moves/creates/deletes file on disk 
	2: Logical: When operation moves/creates/deletes file on memory (only inside the tree)
	3: Both: When operation include both 1 and 2
 */




/// Both, chages node and phisic file to a new destination
- (void) changeParent:(GITreeNode *)newParent;

/// changes flag, loads children if needed.
- (void) expand;

/// changes flag, does not unload children
- (void) collapse;


/// children are unloaded here if needed
- (void) flushCache;

@end
