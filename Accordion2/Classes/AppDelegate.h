//
//  Accordion2AppDelegate.h
//  Accordion2
//
//  Created by Enriquez Gutierrez Guillermo Ignacio on 1/20/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file license.txt for copying permission.
//


#import <UIKit/UIKit.h>


@class DetailViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	
	UIWindow *window;
	UISplitViewController *splitViewController;
	DetailViewController *detailViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
