//
//  CMenuSheet.m
//  TouchCode
//
//  Created by Jonathan Wight on 02/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CMenuSheet.h"

#import "CMenu.h"
#import "CMenuItem.h"

@implementation CMenuSheet

@synthesize menu;

- (id)initWithMenu:(CMenu *)inMenu;
{
if ((self = [super initWithTitle:inMenu.title delegate:self cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL]) != NULL)
	{
	menu = [inMenu retain];
	
	for (CMenuItem *theMenuItem in self.menu.items)
		{
		[self addButtonWithTitle:theMenuItem.title];
		}
	}
return(self);
}

- (void)dealloc
{
[menu release];
menu = NULL;
//
[super dealloc];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
if (buttonIndex == -1)
	return;
CMenuItem *theMenuItem = [self.menu.items objectAtIndex:buttonIndex];
if (theMenuItem.submenu)
	{
	CMenuSheet *theMenuSheet = [[[CMenuSheet alloc] initWithMenu:theMenuItem.submenu] autorelease];
	[theMenuSheet showFromRect:[self.window convertRect:self.bounds fromView:self] inView:self.window animated:YES];
	}
}

@end
