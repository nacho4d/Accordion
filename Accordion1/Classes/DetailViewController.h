//
//  DetailViewController.h
//  Accordion
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 8/27/10.
//  Copyright 2010 Nacho4D. All rights reserved.
//  Cooments, bug and request to: nacho4d@mac.com

#import <UIKit/UIKit.h>

@class N4File;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    id detailItem;
    UILabel *detailDescriptionLabel;
	
	IBOutlet UIImageView *backgroundImageVIew;
	
	NSMutableDictionary *fileViews;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageVIew;

@property (nonatomic, retain) NSMutableDictionary *fileViews;

- (void) addFile:(N4File *)file;
- (void) removeFile:(N4File *)file;

@end
