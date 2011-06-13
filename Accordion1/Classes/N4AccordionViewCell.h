//
//  N4FileTreeCellView.h
//  Accordion
//
//  Created by Ignacio Enriquez Gutierrez on 8/28/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	N4TableViewCellTypeFile,
	N4TableViewCellTypeDirectory
}N4AccordionViewCellType;


@interface N4AccordionViewCell : UITableViewCell {

@private
	IBOutlet UIImageView *directoryAccessoryImageView;
	N4AccordionViewCellType cellType;
	BOOL expanded;
}

@property (nonatomic) N4AccordionViewCellType cellType;
@property (nonatomic, getter=isExpanded) BOOL expanded;
@property (nonatomic, retain) IBOutlet UIImageView *directoryAccessoryImageView;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
