//
//  GIAccordion.h
//  Accordion2
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/20/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GITree.h"

@interface GIAccordion : GITree {
	
	
}

@property (nonatomic, retain) NSMutableArray *selectedNodes;
@property (nonatomic) BOOL isInPseudoEditMode;

@end
