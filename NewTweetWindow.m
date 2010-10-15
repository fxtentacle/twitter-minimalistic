//
//  NewTweetWindow.m
//  TwitterMinimalistic
//
//  Created by Hajo Nils Krabbenhöft on 15.10.10.
//  Copyright 2010 spratpix GmbH & Co. KG. All rights reserved.
//

#import "NewTweetWindow.h"


@implementation NewTweetWindow

@synthesize tweet;
@synthesize count;
@synthesize button;

- (void)awakeFromNib 
{
}

-(void) controlTextDidChange:(NSNotification *)aNotification
{
	NSLog(@"Text changed: %@",[tweet stringValue]);
	if([aNotification object] == tweet)
	{
		int characters = [[tweet stringValue] length];
		if(characters > 140) {
			[button setEnabled:NO];
		} else {
			[button setEnabled:YES];
		}
		[count setStringValue:[NSString stringWithFormat:@"%d", (140-characters)]];
	}
	
}

- (IBAction)done: (id)sender {
	[NSApp stopModal];
}


@end
