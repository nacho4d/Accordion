//
//  GIFileTreeCellView.m
//  Accordion
//
//  Created by Ignacio Enriquez Gutierrez on 8/28/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "GIAccordionViewCell.h"
#import "MGGradientView.h"

@interface GIAccordionViewCell ()
{
	BOOL isShowingEditControl;
	BOOL expanded;
	BOOL isDirectory;
	CALayer *dirAccessoryLayer;
	CALayer *selectedIconLayer;
	
	BOOL inPseudoEditMode;
}
@property (nonatomic, retain) CALayer *dirAccessoryLayer;
@property (nonatomic, retain) CALayer *selectedIconLayer;
@end

@implementation GIAccordionViewCell
@synthesize expanded;
@synthesize dirAccessoryLayer;
@synthesize selectedIconLayer;

- (CALayer *) selectedIconLayer{
	if(!selectedIconLayer){
		selectedIconLayer = [[CALayer layer] retain];
		[self.layer addSublayer:selectedIconLayer];
	}
	return selectedIconLayer;
}

#pragma mark -
#pragma mark public methods

- (id) initWithReuseIdentifier:(NSString *)identifier{
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier])) {
		
		dirAccessoryLayer = [[CALayer layer] retain];
		[self.layer addSublayer:dirAccessoryLayer];
		
		
		self.textLabel.textColor = [UIColor blackColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.textColor= [UIColor grayColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		self.backgroundView = [[[MGGradientView alloc] init] autorelease];
		
		//for Debug
		dirAccessoryLayer.borderColor = [UIColor blackColor].CGColor;
		dirAccessoryLayer.borderWidth = 0.5;
		//self.imageView.layer.borderColor = [UIColor redColor].CGColor;
		//self.textLabel.layer.borderColor = [UIColor blueColor].CGColor;
		//self.detailTextLabel.layer.borderColor = [UIColor greenColor].CGColor;
		//self.detailTextLabel.layer.borderWidth = self.textLabel.layer.borderWidth = self.imageView.layer.borderWidth = 0.5;
		
		expanded = NO;
		isShowingEditControl = NO;
	}
	return self;
}



- (void) setTitle:(NSString *)title{
	self.textLabel.text = title;
}

- (void) setIcon:(UIImage *)icon isDirectory:(BOOL)isDir{
	isDirectory = isDir;
	self.imageView.image = icon;
	self.dirAccessoryLayer.contents = (id)[UIImage imageNamed:(isDirectory)?@"triangleSmall.png":nil].CGImage;	
}

- (void) setPseudoEditingMode:(BOOL)pseudoEditing animated:(BOOL)animated{
	inPseudoEditMode = pseudoEditing;
	if (inPseudoEditMode)
		self.selectedIconLayer.contents = (id)[UIImage imageNamed:@"unselected.png"].CGImage;
	else
		[selectedIconLayer removeFromSuperlayer];
	
	if (animated){
		[UIView animateWithDuration:0.9 animations:^{ [self setNeedsLayout]; }];
	}else{
		[self setNeedsLayout];
	}
}


// override: default implemention shows the +/- in the cells
- (void) setEditing:(BOOL)editing{
	[self setPseudoEditingMode:editing animated:NO];
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
	[self setPseudoEditingMode:editing animated:animated];
}





#pragma mark -
#pragma mark animations

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
	
	NSLog(@"%@", self);
	
	if(inPseudoEditMode){
		self.selectedIconLayer.contents = (id)[UIImage imageNamed:selected?@"selected.png":@"unselected.png"].CGImage;
	}
	[super setSelected:selected animated:animated];
	
	
}
									   

- (void)willTransitionToState:(UITableViewCellStateMask)state{
	[super willTransitionToState:state];
	if (state == UITableViewCellStateShowingEditControlMask) {
		isShowingEditControl = YES;
	}else{
		isShowingEditControl = NO;
	}
}


- (void) layoutSubviews{
	[super layoutSubviews];
	
	float indentation = self.indentationWidth*(self.indentationLevel-1); //+ editIndentation
	float editIndentation = (isShowingEditControl)?30:0; //self.editing is aimai
	float pseudoEditIndentation = inPseudoEditMode?23:0;
	indentation += pseudoEditIndentation;
	float cellHeight = self.frame.size.height;
	static int iconSize = 44;  
	
	if(inPseudoEditMode){
		[self.selectedIconLayer setFrame:CGRectMake(0, 20, 23, 23)];
		self.selectedIconLayer.borderColor = [UIColor blueColor].CGColor;
		self.selectedIconLayer.borderWidth = 1.0f;
	}else{
		//[self.selectedIconLayer setFrame:CGRectZero];
		//self.selectedIconLayer.borderColor = [UIColor blueColor].CGColor;
		//self.selectedIconLayer.borderWidth = 1.0f;
	}
	
	// 11 is (cellHeight-44)/2
	[dirAccessoryLayer setFrame:CGRectMake(indentation + editIndentation, 11, iconSize, iconSize)];
	
	[self.imageView setFrame:CGRectMake(indentation + iconSize, 11, iconSize, iconSize)];
	
	[self.textLabel setFrame:CGRectMake(indentation + 2*iconSize + 5, cellHeight*0.1, 
										self.frame.size.width - 2*iconSize - indentation - 5, cellHeight*0.5)];
	[self.detailTextLabel setFrame:CGRectMake(indentation + 2*iconSize + 5, cellHeight*0.6,  
											  self.frame.size.width - 2*iconSize - indentation - 5, cellHeight*0.3)];
	
}

- (void) dealloc{
	[dirAccessoryLayer release];
	[selectedIconLayer release];
	[super dealloc];
}


- (void) setExpanded:(BOOL)flag{
	if (expanded != flag) {
		expanded = flag;
		
		CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"transform"];
		[ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
		[ani setDuration:0.2];
		[ani setRepeatCount:1.0];
		[ani setAutoreverses:NO];
		[ani setFillMode:kCAFillModeForwards];	//needed so animated object won't go back to its original value after animation
		[ani setRemovedOnCompletion:NO];		//needed so animated object won't go back to its original value after animation
		
		CATransform3D transform = expanded?CATransform3DRotate(self.dirAccessoryLayer.transform, M_PI/2, 0, 0, 1.0):CATransform3DIdentity;
		[ani setToValue:[NSValue valueWithCATransform3D:transform]];
		
		NSString *animationKey = expanded?@"expandingTransform":@"collapsingTransform";
		[self.dirAccessoryLayer addAnimation:ani forKey:animationKey];
	}
}

@end
