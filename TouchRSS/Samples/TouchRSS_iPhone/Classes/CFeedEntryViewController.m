//
//  CFeedEntryViewController.m
//  TouchRSS_iPhone
//
//  Created by Jonathan Wight on 04/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CFeedEntryViewController.h"

#import "CFeedEntry.h"
#import "NSURL_DataExtensions.h"
#import "CTrivialTemplate.h"

@implementation CFeedEntryViewController

@synthesize fetchedResultsController;
@dynamic currentEntryIndex;
@synthesize entry;
@synthesize contentTemplate;
@synthesize nextPreviousSegmentedControl;
@synthesize nextPreviousBarButtonItem;

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)inFetchedResultsController
{
if ((self = [super init]) != NULL)
	{
	fetchedResultsController = [inFetchedResultsController retain];
	
	NSError *theError = NULL;
	[fetchedResultsController performFetch:&theError];
	}
return(self);
}

- (void)dealloc
{

[super dealloc];
}

#pragma mark -

- (void)viewDidLoad
{
[super viewDidLoad];

self.navigationItem.rightBarButtonItem = self.nextPreviousBarButtonItem;
}

#pragma mark -

- (void)updateUI;
{
[super updateUI];
//
NSInteger theCurrentEntryIndex = self.currentEntryIndex;

[self.nextPreviousSegmentedControl setEnabled:theCurrentEntryIndex > 0 forSegmentAtIndex:0];
[self.nextPreviousSegmentedControl setEnabled:theCurrentEntryIndex < self.countOfEntries - 1 forSegmentAtIndex:1];

//if (self.isHome)
//	[self hideToolbar];
//else
//	[self showToolbar];
}

#pragma mark -

- (NSInteger)currentEntryIndex
{
return([self.fetchedResultsController.fetchedObjects indexOfObject:self.entry]);
}

- (void)setCurrentEntryIndex:(NSInteger)inCurrentRow
{
if (inCurrentRow < 0)
	return;
else if (inCurrentRow > [self.fetchedResultsController.fetchedObjects count] - 1)
	return;

CFeedEntry *theEntry = [self.fetchedResultsController.fetchedObjects objectAtIndex:inCurrentRow];
self.entry = theEntry;
}

- (NSInteger)countOfEntries
{
return([self.fetchedResultsController.fetchedObjects count]);
}

- (void)setEntry:(CFeedEntry *)inEntry
{
if (entry != inEntry)
	{
	if (entry != NULL)
		{
		[entry release];
		entry = NULL;
		}
	
	if (inEntry)
		{
		entry = [inEntry retain];
		
		NSDictionary *theReplacementDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
			inEntry, @"entry",
			self, @"controller",
			NULL];
		NSError *theError = NULL;
		NSString *theContent = [self.contentTemplate transform:theReplacementDictionary error:&theError];
		NSData *theData = [theContent dataUsingEncoding:NSUTF8StringEncoding];
		NSURL *theURL = [NSURL dataURLWithData:theData mimeType:@"text/html" charset:@"utf-8"];
		
		[self resetWebView];
		
		self.homeURL = theURL;
		self.requestedURL = theURL;
		}
	}
}

- (CTrivialTemplate *)contentTemplate
{
if (contentTemplate == NULL)
	{
	contentTemplate = [[CTrivialTemplate alloc] initWithTemplateName:@"Entry_Template.html"];
	}
return(contentTemplate);
}

- (UISegmentedControl *)nextPreviousSegmentedControl
{
if (nextPreviousSegmentedControl == NULL)
	{
	NSArray *theItems = [NSArray arrayWithObjects:
		[UIImage imageNamed:@"browser-previous.png"],
		[UIImage imageNamed:@"browser-next.png"],
		NULL
		];
	
	nextPreviousSegmentedControl = [[UISegmentedControl alloc] initWithItems:theItems];
	nextPreviousSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	nextPreviousSegmentedControl.momentary = YES;
	[nextPreviousSegmentedControl addTarget:self action:@selector(actionTest:) forControlEvents:UIControlEventValueChanged];
	}
return(nextPreviousSegmentedControl);
}

- (UIBarButtonItem *)nextPreviousBarButtonItem
{
if (nextPreviousBarButtonItem == NULL)
	{
	nextPreviousBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextPreviousSegmentedControl];
	}
return(nextPreviousBarButtonItem);
}

#pragma mark -

- (IBAction)next:(id)inSender
{
self.currentEntryIndex += 1;
}

- (IBAction)previous:(id)inSender
{
self.currentEntryIndex -= 1;
}

- (IBAction)actionTest:(id)inSender
{
switch ([(UISegmentedControl *)inSender selectedSegmentIndex])
	{
	case 0:
		[self previous:inSender];
		break;
	case 1:
		[self next:inSender];
		break;
	}
}

@end
