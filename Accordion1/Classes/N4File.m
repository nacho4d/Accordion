//
//  File.m
//  MandalaChart
//
//  Created by Ignacio Enriquez Gutierrez on 8/9/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import "N4File.h"


@implementation N4File
@synthesize name, parentDirectory;
@synthesize expanded;
@synthesize level;

//Lazy properties:
- (NSString *) fullName{
	return [parentDirectory stringByAppendingPathComponent:name];
}

- (UIImage *) image{
	if (!image) {
		if ([NSFileTypeDirectory isEqualToString:[self type]]) 
			image = [UIImage imageNamed:@"Folder56.png"];
		else
			image = [UIImage imageNamed:@"Document56.png"];		
	}
	return image;
}
- (UIImage *) imageBig{
	if (!imageBig) {
		if ([NSFileTypeDirectory isEqualToString:[self type]]) 
			imageBig = [UIImage imageNamed:@"Folder512.png"];
		else
			imageBig = [UIImage imageNamed:@"Document512.png"];		
	}
	return imageBig;
	
}
- (NSDate *) creationDate{
	if (!creationDate) {
		NSFileManager *manager = [NSFileManager defaultManager];
		
		creationDate = [[manager attributesOfItemAtPath:[parentDirectory stringByAppendingPathComponent:name] error:NULL]  fileCreationDate]; //objecForKey:NSFileCreatingDate
		//NSLog(@"creationDate: %@", creationDate);
	}
	return creationDate;
}
- (NSDate *) modificationDate{
	NSFileManager *manager = [NSFileManager defaultManager];
	modificationDate = [[manager attributesOfItemAtPath:[parentDirectory stringByAppendingPathComponent:name] error:NULL] fileModificationDate]; //objectForKey:NSFileModificationDate
	return modificationDate;
	
}
- (NSString *) detailText{
	return [[self modificationDate] description];
}

- (NSString *) type{
	if (!type) {
		NSFileManager *manager = [NSFileManager defaultManager];
		type = [[manager attributesOfItemAtPath:[parentDirectory stringByAppendingPathComponent:name] 
											   error:NULL] fileType];
	}
	return type;
}

- (BOOL) isDirectory{
	return	([[self type] isEqualToString:NSFileTypeDirectory]);
}
- (NSString *) description{
	return [NSString stringWithFormat:@"N4File:%@ directory:%@",  [self name], (self.isDirectory)?@"YES": @"NO"];
}
- (BOOL) isEmptyDirectory{
	if (self.isDirectory){
		
		NSFileManager *fm = [NSFileManager defaultManager];
		NSError *error = nil;
		NSArray *subfiles = [fm contentsOfDirectoryAtPath:[self fullName] error:&error];
		if (error) {
			NSLog(@"Error %s: %@", _cmd, [error localizedDescription]);
		}
		if ([subfiles count])
			return NO;
		else
			return YES;
	}
	return NO;
}

#pragma mark -

- (void) loadMembers{
	//TODO: load all members not loaded yet, this should be better than calling NSFileManager for every property.
	fullName = nil;
	type = nil;
	image = nil;
	imageBig = nil;
	creationDate = nil;
	modificationDate = nil;
}

- (void) unloadMembers{
	//TODO: release members and set them to nil
}

- (id) initWithName:(NSString *)aName parentDirectory:(NSString *)aParentDirectory{
	if (self = [super init]) {
		self.name = aName;
		self.parentDirectory = aParentDirectory;
		
		fullName = nil;
		type = nil;
		image = nil;
		imageBig = nil;
		creationDate = nil;
		modificationDate = nil;
		
	}
	return self;
}

- (id) init{
	return [self initWithName:@"" parentDirectory:@""];
}

- (void) dealloc{
	[name release];
	[parentDirectory release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone{
	//Shallow copy : We need a shallow copies here since instances of N4File class 
	//will become keys in NSDictionaries as well and comparing pointers is easier much easier.
	return [self retain];
}

@end
