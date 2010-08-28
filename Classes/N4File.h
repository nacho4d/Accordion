//
//  File.h
//  MandalaChar
//
//  Created by Ignacio Enriquez Gutierrez on 8/9/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface N4File : NSObject <NSCopying> {
	
	NSString *name;
	NSString *parentDirectory;
	
	NSString *fullName;
	NSString *type;
	
	UIImage *image;
	UIImage *imageBig;
	
	NSDate *creationDate;
	NSDate *modificationDate;
	
	BOOL expanded;
	NSInteger level; //used for indentation

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *parentDirectory;

@property (nonatomic, readonly, assign) NSString *fullName;
@property (nonatomic, readonly, assign) NSString *type;

@property (nonatomic, readonly, assign) UIImage *image;
@property (nonatomic, readonly, assign) UIImage *imageBig;
@property (nonatomic, readonly, assign) NSString *detailText;
@property (nonatomic, readonly, assign) NSDate *creationDate;
@property (nonatomic, readonly, assign) NSDate *modificationDate;

@property (nonatomic, readonly) BOOL isDirectory; 
@property (nonatomic, readwrite, getter=isExpanded) BOOL expanded;
@property (nonatomic) NSInteger level;

- (id) initWithName:(NSString *)aName parentDirectory:(NSString *)aParentDirectory;

@end
