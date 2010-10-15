//
//  TwitterMinimalisticAppDelegate.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "TwitterMinimalisticAppDelegate.h"
#import "TwitterForOneUser.h"

@implementation TwitterMinimalisticAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	TwitterForOneUser* twitA = [[TwitterForOneUser alloc] initializeForUsername: @"fxtentacle"];
	TwitterForOneUser* twitB = [[TwitterForOneUser alloc] initializeForUsername: @"spratpix"];
	users = [[NSArray alloc] arrayWithObjects: twitA, twitB, nil];
}




@end
