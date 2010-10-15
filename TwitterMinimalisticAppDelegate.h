//
//  TwitterMinimalisticAppDelegate.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TwitterMinimalisticAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow* window;
	NSArray* users;
}

@property (assign) IBOutlet NSWindow *window;

@end
