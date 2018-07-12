//--------------------------------------------------------
// ORCaen1190Controller
// Created by Mark  A. Howe on Mon May 19 2008
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2008 CENPA, University of Washington. All rights reserved.
//-----------------------------------------------------------
//This program was prepared for the Regents of the University of 
//Washington at the Center for Experimental Nuclear Physics and 
//Astrophysics (CENPA) sponsored in part by the United States 
//Department of Energy (DOE) under Grant #DE-FG02-97ER41020. 
//The University has certain rights in the program pursuant to 
//the contract and the program should not be copied or distributed 
//outside your organization.  The DOE and the University of 
//Washington reserve all rights in the program. Neither the authors,
//University of Washington, or U.S. Government make any warranty, 
//express or implied, or assume any liability or responsibility 
//for the use of this software.
//-------------------------------------------------------------
#import "ORCaen1190Controller.h"
#import "ORCaenDataDecoder.h"
#import "ORCaen1190Model.h"
#import "ORRate.h"
#import "ORRateGroup.h"
#import "ORValueBarGroupView.h"

@implementation ORCaen1190Controller
#pragma mark ***Initialization
- (id) init
{
    self = [ super initWithWindowNibName: @"Caen1190" ];
    return self;
}

- (void) awakeFromNib
{
    setupSize     = NSMakeSize(230,550);
    ratesSize     = NSMakeSize(300,630);

	int i;
	for(i=0;i<32;i++){
		[[enabledMatrix0 cellAtRow:i column:0] setTag:i];
		[[rateMatrix0 cellAtRow:i column:0] setTag:i];
	}
	[super awakeFromNib];
	[valueBar0 setNumber:32 height:10 spacing:5];
}

- (void) setChannelLabels
{
	int i;
	for(i=0;i<32;i++){
		[[channelLabelMatrix0 cellAtRow:i column:0] setTitle:[NSString stringWithFormat:@"%d",i + 32*[model paramGroup]]];
	}
}

#pragma mark •••Notifications
- (void) registerNotificationObservers
{
    [super registerNotificationObservers];
	
	NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
	
	[notifyCenter addObserver: self selector: @selector(enabledMaskChanged:)			name: ORCaen1190EnabledChanged					object: model];
	[notifyCenter addObserver: self selector: @selector(paramGroupChanged:)				name: ORCaen1190ParamGroupChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(acqModeChanged:)				name: ORCaen1190ParamGroupChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(windowWidthChanged:)			name: ORCaen1190WindowWidthChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(windowOffsetChanged:)			name: ORCaen1190WindowOffsetChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(searchMarginChanged:)			name: ORCaen1190SearchMarginChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(rejectMarginChanged:)			name: ORCaen1190RejectMarginChanged				object: model];
	[notifyCenter addObserver: self selector: @selector(edgeDetectionChanged:)			name: ORCaen1190EdgeDetectionChanged			object: model];
	[notifyCenter addObserver: self selector: @selector(deadTimeChanged:)				name: ORCaen1190DeadTimeChanged					object: model];
	[notifyCenter addObserver: self selector: @selector(enableTrigTimeSubChanged:)		name: ORCaen1190EnableTrigTimeSubChanged		object: model];
	[notifyCenter addObserver: self selector: @selector(leadingTrailingLSBChanged:)		name: ORCaen1190LeadingTrailingLSBChanged		object: model];
	[notifyCenter addObserver: self selector: @selector(leadingTimeResolutionChanged:)	name: ORCaen1190LeadingTimeResolutionChanged	object: model];
	[notifyCenter addObserver: self selector: @selector(leadingWidthResolutionChanged:)	name: ORCaen1190LeadingWidthResolutionChanged	object: model];

    [self registerRates];

}

- (void) registerRates
{
    NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
	
	[notifyCenter removeObserver:self name:ORRateChangedNotification object:nil];
	
	NSEnumerator* e = [[[model tdcRateGroup] rates] objectEnumerator];
	id obj;
	while(obj = [e nextObject]){
		[notifyCenter addObserver : self
						 selector : @selector(tdcRateChanged:)
							 name : ORRateChangedNotification
						   object : obj];
	}
}


- (void) updateWindow
{
	[super updateWindow];
	[self paramGroupChanged:nil];
	[self acqModeChanged:nil];
	[self windowWidthChanged:nil];
	[self windowOffsetChanged:nil];
	[self searchMarginChanged:nil];
	[self rejectMarginChanged:nil];
	[self enableTrigTimeSubChanged:nil];
	[self edgeDetectionChanged:nil];
	[self leadingTrailingLSBChanged:nil];
	[self leadingTimeResolutionChanged:nil];
	[self leadingWidthResolutionChanged:nil];
	[self deadTimeChanged:nil];
    [self tdcRateChanged:nil];
}

#pragma mark ***Interface Management
- (void) deadTimeChanged:(NSNotification*)aNote				  { [deadTimePU selectItemAtIndex: [model deadTime]];}
- (void) leadingWidthResolutionChanged:(NSNotification*)aNote {	[leadingWidthResolutionPU selectItemAtIndex: [model leadingWidthResolution]]; }
- (void) leadingTimeResolutionChanged:(NSNotification*)aNote  { [leadingTimeResolutionPU selectItemAtIndex: [model leadingTimeResolution]]; }
- (void) leadingTrailingLSBChanged:(NSNotification*)aNote	  { [leadingTrailingLSBPU selectItemAtIndex: [model leadingTrailingLSB]]; }
- (void) edgeDetectionChanged:(NSNotification*)aNote	 	  { [edgeDetectionPU selectItemAtIndex: [model edgeDetection]]; }
- (void) windowWidthChanged:(NSNotification*)aNote			  { [windowWidthTextField setIntValue:  [model windowWidth]  * 25]; }
- (void) searchMarginChanged:(NSNotification*)aNote			  { [searchMarginTextField setIntValue: [model searchMargin] * 25]; }
- (void) rejectMarginChanged:(NSNotification*)aNote			  { [rejectMarginTextField setIntValue: [model rejectMargin] * 25]; }
- (void) windowOffsetChanged:(NSNotification*)aNote			  { [windowOffsetTextField setIntValue: [model windowOffset] * 25]; }
- (void) enableTrigTimeSubChanged:(NSNotification*)aNote	  { [enableTrigTimeSubCB setIntValue: [model enableTrigTimeSub]];	}  
- (void) acqModeChanged:(NSNotification*)aNote				  { [acqModePU selectItemAtIndex: [model acqMode]]; }
- (void) paramGroupChanged:(NSNotification*)aNote
{
	[paramGroupField setIntValue: [model paramGroup]];
	[self setChannelLabels];
	[self enabledMaskChanged:nil];
}

- (void) enabledMaskChanged:(NSNotification*)aNote
{
	int i;
	unsigned long aMask = [model enabledMask:[model paramGroup]];
	for(i=0;i<32;i++){
		[[enabledMatrix0  cellWithTag:i] setIntValue:aMask&(1<<i)];
	}
}

- (void) tdcRateChanged:(NSNotification*)aNote
{
	ORRate* theRateObj = [aNote object];	
	if([model paramGroup] == ([theRateObj tag]/32)) {		
		[[rateMatrix0 cellWithTag:[theRateObj tag]%32] setFloatValue: [theRateObj rate]];
		[valueBar0 setNeedsDisplay:YES];
	}
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    if([tabView indexOfTabViewItem:tabViewItem] == 0){
		[[self window] setContentView:blankView];
		[self resizeWindowToSize:settingSize];
		[[self window] setContentView:tabView];
    }
    else if([tabView indexOfTabViewItem:tabViewItem] == 1){
		[[self window] setContentView:blankView];
		[self resizeWindowToSize:setupSize];
		[[self window] setContentView:tabView];
    }
    else if([tabView indexOfTabViewItem:tabViewItem] == 2){
		[[self window] setContentView:blankView];
		[self resizeWindowToSize:ratesSize];
		[[self window] setContentView:tabView];
    }

    NSString* key = [NSString stringWithFormat: @"orca.ORCaenCard%d.selectedtab",[model slot]];
    int index = (int)[tabView indexOfTabViewItem:tabViewItem];
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:key];
}

#pragma mark ***Interface Management - Module specific
- (NSString*) basicLockName     { return @"ORCaen1190BasicLock"; }

#pragma mark •••Actions

- (IBAction) deadTimeAction:(id)sender				   { [model setDeadTime:				(int)[sender indexOfSelectedItem]];	}
- (IBAction) leadingWidthResolutionAction:(id)sender   { [model setLeadingWidthResolution:	(int)[sender indexOfSelectedItem]];	}
- (IBAction) leadingTimeResolutionAction:(id)sender	   { [model setLeadingTimeResolution:	(int)[sender indexOfSelectedItem]];	}
- (IBAction) leadingTrailingLSBAction:(id)sender	   { [model setLeadingTrailingLSB:		(int)[sender indexOfSelectedItem]];	}
- (IBAction) edgeDetectionAction:(id)sender			   { [model setEdgeDetection:			(int)[sender indexOfSelectedItem]];	}
- (IBAction) windowWidthAction:(id)sender			   { [model setWindowWidth:				[sender intValue] / 25]; }
- (IBAction) searchMarginAction:(id)sender			   { [model setSearchMargin:			[sender intValue] / 25]; }
- (IBAction) rejectMarginAction:(id)sender			   { [model setRejectMargin:			[sender intValue] / 25]; }
- (IBAction) windowOffsetAction:(id)sender			   { [model setWindowOffset:			[sender intValue] / 25]; } 
- (IBAction) enableTrigTimeSubAction:(id)sender		   { [model setEnableTrigTimeSub:		[sender intValue]]; }
- (IBAction) acqModeAction:(id)sender				   { [model setAcqMode:					(int)[sender indexOfSelectedItem]]; }
- (IBAction) paramGroupAction:(id)sender			   { [model setParamGroup:				[sender intValue]]; }
- (IBAction) loadDefaultsAction:(id)sender			   { [model loadDefaults]; }

- (IBAction) enabledMatrixAction:(id)sender
{
	unsigned long aMask = 0;
	int i;
	for(i=0;i<32;i++){
		if([[enabledMatrix0 cellWithTag:i] intValue])aMask |= (1<<i);
	}
	[model setEnabledMask:[model paramGroup] withValue:aMask];
}

- (IBAction) enabledAllAction:(id)sender	{ [model setEnabledMask:[model paramGroup] withValue:0xFFFFFFFF]; }
- (IBAction) enabledNoneAction:(id)sender	{ [model setEnabledMask:[model paramGroup] withValue:0]; }
- (IBAction) incGroupAction:(id)sender		{ [model setParamGroup:	[model paramGroup] + 1];}
- (IBAction) decGroupAction:(id)sender		{ [model setParamGroup:	[model paramGroup] - 1];}

@end
