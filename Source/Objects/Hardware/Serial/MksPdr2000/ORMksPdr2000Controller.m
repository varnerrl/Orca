//--------------------------------------------------------
// ORMksPdr2000Controller
// Created by Mark  A. Howe on Tue Jan 6, 2009
// Code partially generated by the OrcaCodeWizard. Written by Mark A. Howe.
// Copyright (c) 2005 CENPA, University of Washington. All rights reserved.
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

#pragma mark ***Imported Files

#import "ORMksPdr2000Controller.h"
#import "ORMksPdr2000Model.h"
#import "ORTimeLinePlot.h"
#import "ORCompositePlotView.h"
#import "ORTimeAxis.h"
#import "ORSerialPortList.h"
#import "ORSerialPort.h"
#define __CARBONSOUND__ //temp until undated to >10.3
#import <Carbon/Carbon.h>
#import "ORTimeRate.h"

@interface ORMksPdr2000Controller (private)
- (void) populatePortListPopup;
@end

@implementation ORMksPdr2000Controller

#pragma mark ***Initialization

- (id) init
{
	self = [super initWithWindowNibName:@"MksPdr2000"];
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) awakeFromNib
{
    [self populatePortListPopup];
    [[plotter0 yAxis] setRngLow:0.0 withHigh:1000.];
	[[plotter0 yAxis] setRngLimitsLow:0.0 withHigh:100000 withMinRng:10];
	[plotter0 setUseGradient:YES];

    [[plotter0 xAxis] setRngLow:0.0 withHigh:10000];
	[[plotter0 xAxis] setRngLimitsLow:0.0 withHigh:200000. withMinRng:200];

	ORTimeLinePlot* aPlot;
	aPlot= [[ORTimeLinePlot alloc] initWithTag:0 andDataSource:self];
	[plotter0 addPlot: aPlot];
	[(ORTimeAxis*)[plotter0 xAxis] setStartTime: [[NSDate date] timeIntervalSince1970]];
	[aPlot release];
	
	aPlot = [[ORTimeLinePlot alloc] initWithTag:1 andDataSource:self];
	[plotter0 addPlot: aPlot];
	[aPlot setLineColor:[NSColor blackColor]];
	[(ORTimeAxis*)[plotter0 xAxis] setStartTime: [[NSDate date] timeIntervalSince1970]];
	[aPlot release];
	
	[super awakeFromNib];
}

#pragma mark ***Notifications

- (void) registerNotificationObservers
{
	NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    [super registerNotificationObservers];
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORRunStatusChangedNotification
                       object : nil];
    
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORMksPdr2000Lock
                        object: nil];

    [notifyCenter addObserver : self
                     selector : @selector(portNameChanged:)
                         name : ORMksPdr2000ModelPortNameChanged
                        object: nil];

    [notifyCenter addObserver : self
                     selector : @selector(portStateChanged:)
                         name : ORSerialPortStateChanged
                       object : nil];
                                              
    [notifyCenter addObserver : self
                     selector : @selector(pressureChanged:)
                         name : ORMksPdr2000PressureChanged
                       object : nil];

    [notifyCenter addObserver : self
                     selector : @selector(pollTimeChanged:)
                         name : ORMksPdr2000ModelPollTimeChanged
                       object : nil];

    [notifyCenter addObserver : self
                     selector : @selector(shipPressuresChanged:)
                         name : ORMksPdr2000ModelShipPressuresChanged
						object: model];

    [notifyCenter addObserver : self
					 selector : @selector(scaleAction:)
						 name : ORAxisRangeChangedNotification
					   object : nil];

    [notifyCenter addObserver : self
					 selector : @selector(miscAttributesChanged:)
						 name : ORMiscAttributesChanged
					   object : model];

    [notifyCenter addObserver : self
					 selector : @selector(updateTimePlot:)
						 name : ORRateAverageChangedNotification
					   object : nil];
					   
    [notifyCenter addObserver : self
                     selector : @selector(pressureScaleChanged:)
                         name : ORMksPdr2000ModelPressureScaleChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(unitsChanged:)
                         name : ORMksPdr2000ModelUnitsChanged
						object: model];

}

- (void) setModel:(id)aModel
{
	[super setModel:aModel];
	[[self window] setTitle:[NSString stringWithFormat:@"MKS PDR2000 (Unit %lu)",[model uniqueIdNumber]]];
}

- (void) updateWindow
{
    [super updateWindow];
    [self lockChanged:nil];
    [self portStateChanged:nil];
    [self portNameChanged:nil];
	[self pressureChanged:nil];
	[self pollTimeChanged:nil];
	[self shipPressuresChanged:nil];
	[self updateTimePlot:nil];
    [self miscAttributesChanged:nil];
	[self pressureScaleChanged:nil];
	[self unitsChanged:nil];
}

- (void) unitsChanged:(NSNotification*)aNote
{
	[unitsTextField setStringValue: [model units]];
	[unitsTextField1 setStringValue: [NSString stringWithFormat:@"(%@)",[model units]]];
}

- (void) pressureScaleChanged:(NSNotification*)aNote
{
	[pressureScalePU selectItemAtIndex: [model pressureScale]];
	[plotter0 setNeedsDisplay:YES];
}

- (void) scaleAction:(NSNotification*)aNotification
{
	if(aNotification == nil || [aNotification object] == [plotter0 xAxis]){
		[model setMiscAttributes:[(ORAxis*)[plotter0 xAxis]attributes] forKey:@"XAttributes0"];
	};
	
	if(aNotification == nil || [aNotification object] == [plotter0 yAxis]){
		[model setMiscAttributes:[(ORAxis*)[plotter0 yAxis]attributes] forKey:@"YAttributes0"];
	};

}

- (void) miscAttributesChanged:(NSNotification*)aNote
{

	NSString*				key = [[aNote userInfo] objectForKey:ORMiscAttributeKey];
	NSMutableDictionary* attrib = [model miscAttributesForKey:key];
	
	if(aNote == nil || [key isEqualToString:@"XAttributes0"]){
		if(aNote==nil)attrib = [model miscAttributesForKey:@"XAttributes0"];
		if(attrib){
			[(ORAxis*)[plotter0 xAxis] setAttributes:attrib];
			[plotter0 setNeedsDisplay:YES];
			[[plotter0 xAxis] setNeedsDisplay:YES];
		}
	}
	if(aNote == nil || [key isEqualToString:@"YAttributes0"]){
		if(aNote==nil)attrib = [model miscAttributesForKey:@"YAttributes0"];
		if(attrib){
			[(ORAxis*)[plotter0 yAxis] setAttributes:attrib];
			[plotter0 setNeedsDisplay:YES];
			[[plotter0 yAxis] setNeedsDisplay:YES];
		}
	}

}

- (void) updateTimePlot:(NSNotification*)aNote
{
	if(!aNote || ([aNote object] == [model timeRate:0])){
		[plotter0 setNeedsDisplay:YES];
	}
}

- (void) shipPressuresChanged:(NSNotification*)aNote
{
	[shipPressuresButton setIntValue: [model shipPressures]];
}

- (void) pressureChanged:(NSNotification*)aNote
{
	if(aNote){
		int index = [[[aNote userInfo] objectForKey:@"Index"] intValue];
		[self loadPressureTimeValuesForIndex:index];
	}
	else {
		int i;
		for(i=0;i<2;i++){
			[self loadPressureTimeValuesForIndex:i];
		}
	}
}

- (void) loadPressureTimeValuesForIndex:(int)index
{
	NSString* pressureAsString = [NSString stringWithFormat:@"%.2E",[model pressure:index]];
	[[pressureMatrix cellWithTag:index] setStringValue:pressureAsString];
	[[pressure1Matrix cellWithTag:index] setStringValue:pressureAsString];
	unsigned long t = [model timeMeasured:index];
	NSDate* theDate;
	if(t){
		theDate = [NSDate dateWithTimeIntervalSince1970:t];
		[[timeMatrix cellWithTag:index] setObjectValue:[theDate descriptionFromTemplate:@"MM/dd HH:mm:ss"]];
	}
	else [[timeMatrix cellWithTag:index] setObjectValue:@"--"];
}

- (void) checkGlobalSecurity
{
    BOOL secure = [[[NSUserDefaults standardUserDefaults] objectForKey:OROrcaSecurityEnabled] boolValue];
    [gSecurity setLock:ORMksPdr2000Lock to:secure];
    [lockButton setEnabled:secure];
}

- (void) lockChanged:(NSNotification*)aNotification
{

    BOOL runInProgress = [gOrcaGlobals runInProgress];
    BOOL lockedOrRunningMaintenance = [gSecurity runInProgressButNotType:eMaintenanceRunType orIsLocked:ORMksPdr2000Lock];
    BOOL locked = [gSecurity isLocked:ORMksPdr2000Lock];

    [lockButton setState: locked];

    [portListPopup setEnabled:!locked];
    [openPortButton setEnabled:!locked];
    [pollTimePopup setEnabled:!locked];
    [shipPressuresButton setEnabled:!locked];
    
    NSString* s = @"";
    if(lockedOrRunningMaintenance){
        if(runInProgress && ![gSecurity isLocked:ORMksPdr2000Lock])s = @"Not in Maintenance Run.";
    }
    [lockDocField setStringValue:s];

}

- (void) portStateChanged:(NSNotification*)aNotification
{
    if(aNotification == nil || [aNotification object] == [model serialPort]){
        if([model serialPort]){
            [openPortButton setEnabled:YES];

            if([[model serialPort] isOpen]){
                [openPortButton setTitle:@"Close"];
                [portStateField setTextColor:[NSColor colorWithCalibratedRed:0.0 green:.8 blue:0.0 alpha:1.0]];
                [portStateField setStringValue:@"Open"];
            }
            else {
                [openPortButton setTitle:@"Open"];
                [portStateField setStringValue:@"Closed"];
                [portStateField setTextColor:[NSColor redColor]];
            }
        }
        else {
            [openPortButton setEnabled:NO];
            [portStateField setTextColor:[NSColor blackColor]];
            [portStateField setStringValue:@"---"];
            [openPortButton setTitle:@"---"];
        }
    }
}

- (void) pollTimeChanged:(NSNotification*)aNotification
{
	[pollTimePopup selectItemWithTag:[model pollTime]];
}

- (void) portNameChanged:(NSNotification*)aNotification
{
    NSString* portName = [model portName];
    
	NSEnumerator *enumerator = [ORSerialPortList portEnumerator];
	ORSerialPort *aPort;

    [portListPopup selectItemAtIndex:0]; //the default
    while (aPort = [enumerator nextObject]) {
        if([portName isEqualToString:[aPort name]]){
            [portListPopup selectItemWithTitle:portName];
            break;
        }
	}  
    [self portStateChanged:nil];
}


#pragma mark ***Actions

- (void) pressureScaleAction:(id)sender
{
	[model setPressureScale:(int)[sender indexOfSelectedItem]];
}

- (void) shipPressuresAction:(id)sender
{
	[model setShipPressures:[sender intValue]];	
}

- (IBAction) lockAction:(id) sender
{
    [gSecurity tryToSetLock:ORMksPdr2000Lock to:[sender intValue] forWindow:[self window]];
}

- (IBAction) portListAction:(id) sender
{
    [model setPortName: [portListPopup titleOfSelectedItem]];
}

- (IBAction) openPortAction:(id)sender
{
    [model openPort:![[model serialPort] isOpen]];
}

- (IBAction) readPressuresAction:(id)sender
{
	[model readPressures];
}

- (IBAction) pollTimeAction:(id)sender
{
	[model setPollTime:(int)[[sender selectedItem] tag]];
}

#pragma mark •••Data Source
- (int) numberPointsInPlot:(id)aPlotter
{
	return (int)[[model timeRate:(int)[aPlotter tag]] count];
}

- (void) plotter:(id)aPlotter index:(int)i x:(double*)xValue y:(double*)yValue
{
	int set = (int)[aPlotter tag];
	int count = (int)[[model timeRate:set] count];
	int index = count-i-1;
	*xValue = [[model timeRate:set]timeSampledAtIndex:index];;
	*yValue = [[model timeRate:set] valueAtIndex:index] * [model pressureScaleValue];
}

@end

@implementation ORMksPdr2000Controller (private)

- (void) populatePortListPopup
{
	NSEnumerator *enumerator = [ORSerialPortList portEnumerator];
	ORSerialPort *aPort;
    [portListPopup removeAllItems];
    [portListPopup addItemWithTitle:@"--"];

	while (aPort = [enumerator nextObject]) {
        [portListPopup addItemWithTitle:[aPort name]];
	}    
}
@end

