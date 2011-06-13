//
//  N4FileTreeCellView.m
//  Accordion
//
//  Created by Ignacio Enriquez Gutierrez on 8/28/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import "N4AccordionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation N4AccordionViewCell
@synthesize cellType, expanded;
@synthesize directoryAccessoryImageView;

- (void) setType:(N4AccordionViewCellType)newType{
	cellType = newType;
	if (cellType == N4TableViewCellTypeFile ) 
		directoryAccessoryImageView.image = nil;
}

- (id) initWithReuseIdentifier:(NSString *)identifier{
	if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
		
		directoryAccessoryImageView = [[UIImageView alloc] init];
		directoryAccessoryImageView.contentMode = UIViewContentModeCenter;
		[self addSubview:directoryAccessoryImageView];
		
		self.textLabel.textColor = [UIColor blackColor];
		self.detailTextLabel.textColor= [UIColor grayColor];
		
		cellType = N4TableViewCellTypeFile;
		expanded = NO;
	}
	return self;
}

- (void) layoutSubviews{
	//NSLog(@"%s", _cmd);
	[super layoutSubviews];
	float editIndentation = self.editing ? 30 : 0;
	float height = self.frame.size.height;
	float indentation = self.indentationWidth*self.indentationLevel;
	[directoryAccessoryImageView setFrame:CGRectMake(indentation + editIndentation, 0, height, height)];
	[self.imageView setFrame:CGRectMake(indentation + height, 0, height, height)];
	
	[self.textLabel setFrame:CGRectMake(indentation + 2*height + 5 , height*0.1 , 
										self.frame.size.width - 2*height - indentation - 5, height*0.5)];
	[self.detailTextLabel setFrame:CGRectMake(indentation + 2*height + 5, height*0.6,  
											  self.frame.size.width - 2*height - indentation - 5, height*0.3)];
	
}

- (void) dealloc{
	
	[directoryAccessoryImageView release];
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
		[ani setDelegate:self];
		
		if (expanded == YES) {
			CATransform3D newTransform = CATransform3DRotate(self.directoryAccessoryImageView.layer.transform, M_PI/2, 0, 0, 1.0);
			[ani setToValue:[NSValue valueWithCATransform3D:newTransform]];
			[self.directoryAccessoryImageView.layer addAnimation:ani forKey:@"expandingTransform"];
			
		}else{
			CATransform3D newTransform = CATransform3DRotate(self.directoryAccessoryImageView.layer.transform, -M_PI/2, 0, 0, 1.0);
			[ani setToValue:[NSValue valueWithCATransform3D:newTransform]];
			[self.directoryAccessoryImageView.layer addAnimation:ani forKey:@"collapsingTransform"];
		}
	}
}

- (void)animationDidStop:(CAAnimation *)ani finished:(BOOL)flag{
	CATransform3D newTransform = [[(CABasicAnimation *)ani toValue] CATransform3DValue];
	[self.directoryAccessoryImageView.layer setTransform:newTransform];
}
@end
