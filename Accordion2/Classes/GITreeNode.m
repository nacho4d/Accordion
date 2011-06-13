//
//  GITreeNode.m
//  dictionary
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/9/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import "GITreeNode.h"

@interface GITreeNode ()

/// redefining exposed parentPath property as retain
@property (nonatomic, retain) NSString *parentPath;

/// internal property, lazy loaded
@property (nonatomic, retain, readonly) NSDictionary *properties;

///  internal property, always reads properties from disk
@property (nonatomic, assign, readonly) NSDictionary *nonCashedProperties;


@end


@interface GITreeNode (privates)

/// Logical, simply adds a new child to current directory node, should this be private?
- (void) _appendChild:(GITreeNode *)newChild;


/// loads children (retains it, so children must be released later)
- (void) _loadChildren;

@end


@implementation GITreeNode


//#define GIASSERT(error, method) 
#define GIASSERT(error, method) if ((error)) NSLog(@"ERROR: %s: %@", (method), [(error) localizedDescription]);

#pragma mark -
#pragma mark properties

- (NSDictionary *) nonCashedProperties{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	NSString *path = self.absolutePath;
	NSDictionary *props = [fm attributesOfItemAtPath:path error:&error];
	//GIASSERT(error, _cmd);
	return props;
}

- (NSDictionary *)properties{
	if (!_properties) {
		_properties = [[self nonCashedProperties] retain];
	}
	return _properties;
}

@synthesize filename = _name;

- (NSString *)absolutePath{
	return (self.parent)?
	[self.parent.absolutePath stringByAppendingPathComponent:self.filename]:
	[self.parentPath stringByAppendingPathComponent:self.filename];
}

- (NSString *)fileExtension{
	return [[self.filename lastPathComponent] pathExtension];
}

- (BOOL) isDirectory{
	return [NSFileTypeDirectory isEqualToString:[self.properties fileType]];
}

//- (BOOL) directoryIsExpanded{
//	return (self.isDirectory && _children);
//}

- (void) _loadChildren{ 
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	NSArray *paths = [fm contentsOfDirectoryAtPath:self.absolutePath error:&error];
	//GIASSERT(error, _cmd);
	_children = [[NSMutableArray alloc] init];
	for (NSString *path in paths) {
		GITreeNode *childNode = [[GITreeNode alloc] initWithName:path parent:self];
		[_children addObject:childNode];
		[childNode release];
	}
	
}

- (NSMutableArray *) children{
	if (self.isDirectory && !_children) {
		[self _loadChildren]; //_children is alloc/init must be released later
	}
	return _children;
}

@synthesize parent = _parent;
@synthesize parentPath = _parentPath;

- (NSDate *) creationDate{
	return [self.properties fileCreationDate]; //cashed properties
}
- (NSDate *) modificationDate{
	return [self.properties fileModificationDate];
}
- (void) setModificationDate:(NSDate *)date{
	//to do this _properties has to be mutable or create a new object _properties
}

- (NSInteger) depth{
	if (_depth == -1) {
		_depth = self.parent.depth + 1;
	}
	return _depth;
}

@synthesize directoryIsExpanded = _expanded;

#pragma mark -
#pragma mark Life Cicle 

- (void) dealloc{
	[_name release];
	_parent = nil;
	[_parentPath release];
	[_properties release];
	[_children release];
	[super dealloc];
}

- (id) initWithName:(NSString *)name parent:(GITreeNode *)aParent{
	if ((self = [super init])){
		_name = [name retain];
		_parent = aParent;
		_parentPath = nil;	
		_properties = nil;
		_children = nil;
		_depth = -1;
		_expanded = NO;
	}
	return self;
}

- (id) initWithName:(NSString *)name parentPath:(NSString *)aParentPath{
	if ((self = [super init])){
		_name = [name retain];
		_parent = nil;
		_parentPath = [aParentPath retain];	
		_properties = nil;
		_children = nil;
		_depth = 0;
		_expanded = NO;
	}
	return self;
}

#pragma mark -
#pragma mark public methods

- (void) appendChild:(GITreeNode *)newChild{
	[self.children addObject:newChild];
	
}

- (void) changeParent:(GITreeNode *)newParent{

	NSString *oldPath = self.absolutePath;
	[newParent appendChild:self];
	[self.parent.children removeObject:self];
	_parent = newParent;
	NSString *newPath = self.absolutePath;
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error = nil;
	[fm moveItemAtPath:oldPath toPath:newPath error:&error];
	//GIASSERT(error, _cmd);
		
}


- (void) expand{
	if (self.isDirectory && !self.directoryIsExpanded){
		if (!_children)	[self _loadChildren];
		_expanded = YES;
	}
}
- (void) collapse{
	_expanded = NO; //objects will be released when memory is needed
}

- (void) flushCache{
	if (!self.directoryIsExpanded) {
		[_children release];
		_children = nil;
	}
	
	[_properties release];
	_properties = nil;
}

NSString *space(int x){
	NSMutableString *res = [NSMutableString string];
	for (int i =0; i<x; i++) {
		[res appendString:@" "];
	}
	return res;
}

- (NSString *) description{
	
	return [NSString stringWithFormat:@"%@%@ %@", space(self.depth),self.isDirectory?@"D":@"F", self.filename];
}
@end
