//
//  N4FileView.m
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/30/10.
//  Copyright (c) 2010 Nacho4D.
//  See the file license.txt for copying permission.
//

#import "N4FileView.h"


@implementation N4FileView
@synthesize file;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void) writeToDisk{
}

- (void) loadView{
	[self setAlpha:0.4];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 60)];
	[label setText:[file name]];
	[self addSubview:label];
	[label release];
	
}
- (void) setFile:(N4File *)aFile{
	file = aFile;
	[self loadView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	file = nil;
    [super dealloc];
}


@end
