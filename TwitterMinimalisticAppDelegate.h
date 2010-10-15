//
//  TwitterMinimalisticAppDelegate.h
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGTwitterEngine/MGTwitterEngine.h>

@interface TwitterMinimalisticAppDelegate : NSObject <NSApplicationDelegate, MGTwitterEngineDelegate> {
    MGTwitterEngine *twitterEngine;
	
	OAToken *token;

    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
