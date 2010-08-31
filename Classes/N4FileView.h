//
//  N4FileView.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/30/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class N4File;
@interface N4FileView : UIView {
	N4File *file;
	CALayer *mainBlock;
	NSMutableArray *datacontainingtextandtitleslayers;
}

@property (nonatomic, assign) N4File *file;

- (void) writeToDisk;
- (void) loadView;

@end
