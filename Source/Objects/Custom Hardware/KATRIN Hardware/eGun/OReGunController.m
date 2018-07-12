//--------------------------------------------------------
// OReGunController
// Created by Mark  A. Howe on Wed Nov 28, 2007
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

#import "OReGunController.h"
#import "OReGunModel.h"
#import "ORVectorPlot.h"
#import "ORPlotView.h"
#import "ORAxis.h"
#import "ORIP220Model.h"
#import "ORObjectProxy.h"
#import "ORCompositePlotView.h"
#define __CARBONSOUND__ //temp until undated to >10.3
#import <Carbon/Carbon.h>

@implementation OReGunController

#pragma mark ***Initialization

- (id) init
{
	self = [super initWithWindowNibName:@"eGun"];
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) awakeFromNib
{
	[[xyPlot xAxis] setInteger:YES];
	[xyPlot setUseGradient:NO];
    [xyPlot setBackgroundColor:[NSColor colorWithCalibratedRed:.9 green:1.0 blue:.9 alpha:1.0]];
	[xyPlot setShowGrid:NO];
	
	ORVectorPlot* aPlot;
	aPlot = [[ORVectorPlot alloc] initWithTag:0 andDataSource:self];
	[xyPlot addPlot: aPlot];
	[aPlot release];
	
	[xyPlot setXLabel:@"X Position (mm)"];
	[xyPlot setYLabel:@"Y Position (mm)"];
	[super awakeFromNib];
}


#pragma mark ***Notifications

- (void) registerNotificationObservers
{
	NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    [super registerNotificationObservers];
	
	[notifyCenter addObserver: self
					 selector: @selector( proxyChanged: )
						 name: ORObjectProxyChanged
					   object: nil];
	
	[notifyCenter addObserver: self
					 selector: @selector( proxyChanged: )
						 name: ORObjectProxyNumberChanged
					   object: nil];
	
	[notifyCenter addObserver : self
                     selector : @selector(proxyChanged:)
                         name : ORDocumentLoadedNotification
                       object : nil];
	
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORRunStatusChangedNotification
                       object : nil];
    
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : OReGunLock
                        object: nil];
	
    [notifyCenter addObserver : self
                     selector : @selector(positionChanged:)
                         name : OReGunModelPositionChanged
                       object : model];
	
    [notifyCenter addObserver : self
                     selector : @selector(absMotionChanged:)
                         name : OReGunModelAbsMotionChanged
                       object : model];
		
    [notifyCenter addObserver : self
                     selector : @selector(chanChanged:)
                         name : OReGunModelChanXChanged
						object: model];
	
    [notifyCenter addObserver : self
                     selector : @selector(chanChanged:)
                         name : OReGunModelChanYChanged
						object: model];
	
    [notifyCenter addObserver : self
                     selector : @selector(cmdPositionChanged:)
                         name : OReGunModelCmdPositionChanged
						object: model];
	
    [notifyCenter addObserver : self
                     selector : @selector(millimetersPerVoltChanged:)
                         name : OReGunModelMillimetersPerVoltChanged
						object: model];
	
    [notifyCenter addObserver : self
                     selector : @selector(movingChanged:)
                         name : OReGunModelMovingChanged
						object: model];
		
    [notifyCenter addObserver : self
                     selector : @selector(viewTypeChanged:)
                         name : OReGunModelViewTypeChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(excursionChanged:)
                         name : OReGunModelExcursionChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(decayRateChanged:)
                         name : OReGunModelDecayRateChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(decayTimeChanged:)
                         name : OReGunModelDecayTimeChanged
						object: model];
    [notifyCenter addObserver : self
                     selector : @selector(stateStringChanged:)
                         name : OReGunModelStateStringChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(overshootChanged:)
                         name : OReGunModelOvershootChanged
						object: model];

    [notifyCenter addObserver : self
                     selector : @selector(stepTimeChanged:)
                         name : OReGunModelStepTimeChanged
						object: model];

}

- (void) updateWindow
{
    [super updateWindow];
    [self lockChanged:nil];
    [self cmdPositionChanged:nil];
    [self absMotionChanged:nil];
	[self chanChanged:nil];
	[self movingChanged:nil];
	[self millimetersPerVoltChanged:nil];
	[self proxyChanged:nil];
	[self viewTypeChanged:nil];
	[self excursionChanged:nil];
	[self decayRateChanged:nil];
	[self decayTimeChanged:nil];
	[self stateStringChanged:nil];
	[self overshootChanged:nil];
	[self stepTimeChanged:nil];
}

- (void) stepTimeChanged:(NSNotification*)aNote
{
	[stepTimeTextField setFloatValue: [model stepTime]];
}

- (void) overshootChanged:(NSNotification*)aNote
{
	[overshootTextField setFloatValue: [model overshoot]];
}

- (void) stateStringChanged:(NSNotification*)aNote
{
	if([model stateString])[stateStringTextField setStringValue: [model stateString]];
	else [stateStringTextField setStringValue: @""];
}


- (void) decayTimeChanged:(NSNotification*)aNote
{
	[decayTimeTextField setFloatValue: [model decayTime]];
}

- (void) decayRateChanged:(NSNotification*)aNote
{
	[decayRateTextField setFloatValue: [model decayRate]];
}

- (void) excursionChanged:(NSNotification*)aNote
{
	[excursionTextField setFloatValue: [model excursion]];
}

- (void) viewTypeChanged:(NSNotification*)aNote
{
    [viewTypeMatrix selectCellWithTag:[model viewType]];

	float r;
	if(![model viewType]){
		[xyPlot setBackgroundImage:[NSImage imageNamed:@"mainFocalPlaneDetector"]];
		r = 47;
	}
	else {
		[xyPlot setBackgroundImage:nil];
		r = 200;
	}
	[[xyPlot xAxis] setRngDefaultsLow:-r withHigh:r];
    [[xyPlot xAxis] setRngLimitsLow:-r withHigh:r withMinRng:2*r];
	[[xyPlot yAxis] setRngDefaultsLow:-r withHigh:r];
    [[xyPlot yAxis] setRngLimitsLow:-r withHigh:r withMinRng:2*r];
	[xyPlot setNeedsDisplay:YES];
	
}

- (void) millimetersPerVoltChanged:(NSNotification*)aNote
{
	[millimetersPerVoltTextField setFloatValue: [model millimetersPerVolt]];
}

- (void) movingChanged:(NSNotification*)aNote
{
	[goButton setEnabled:![model moving]];
	[stopButton setEnabled:[model moving]];
	[moveStatusField setStringValue:[model moving]?@"Moving":@""];
	[xyPlot setNeedsDisplay:YES];
}

- (void) chanChanged:(NSNotification*)aNote
{
	[[channelMatrix cellWithTag:0] setIntValue:[model chanX]];
	[[channelMatrix cellWithTag:1] setIntValue:[model chanY]];
}

- (void) proxyChanged:(NSNotification*) aNote
{
	if([aNote object] == [model x220Object] || !aNote){
		[[model x220Object] populatePU:interfaceObjPUx];
		[[model x220Object] selectItemForPU:interfaceObjPUx];
	}
	if([aNote object] == [model y220Object] || !aNote){
		[[model y220Object] populatePU:interfaceObjPUy];
		[[model y220Object] selectItemForPU:interfaceObjPUy];
	}
	[self positionChanged:nil];
}

- (void) checkGlobalSecurity
{
    BOOL secure = [[[NSUserDefaults standardUserDefaults] objectForKey:OROrcaSecurityEnabled] boolValue];
    [gSecurity setLock:OReGunLock to:secure];
    [lockButton setEnabled:secure];
}

- (void) lockChanged:(NSNotification*)aNote
{
    BOOL locked = [gSecurity isLocked:OReGunLock];

    [lockButton setState: locked];

    [getPositionButton setEnabled:!locked];
    [cmdMatrix setEnabled:!locked];
    [channelMatrix setEnabled:!locked];
    [absMatrix setEnabled:!locked];
    [goButton setEnabled:!locked];

}

- (void) absMotionChanged:(NSNotification*)aNote
{
    [absMatrix selectCellWithTag:[model absMotion]];
    if([model absMotion]){
        [moveLabelField setStringValue:@"Go To:"];
        [goButton setTitle:@"Go To"];
    }
    else {
        [moveLabelField setStringValue:@"Move:"];
        [goButton setTitle:@"Move"];
    }
}

- (void) cmdPositionChanged:(NSNotification*)aNote
{
	float millimetersPerVolt = [model millimetersPerVolt];
 	[[cmdMatrix cellWithTag:0] setFloatValue:[model cmdPosition].x*millimetersPerVolt];
	[[cmdMatrix cellWithTag:1] setFloatValue:[model cmdPosition].y*millimetersPerVolt];
}


- (void) positionChanged:(NSNotification*)aNote
{
	[xyPlot setNeedsDisplay:YES];
	float millimetersPerVolt = [model millimetersPerVolt];
	NSPoint xyVoltage = [model xyVoltage];
	[xPositionField setFloatValue:(xyVoltage.x + 0.01*xyVoltage.y)*millimetersPerVolt];
	[yPositionField setFloatValue:(xyVoltage.y + 0.01*xyVoltage.x)*millimetersPerVolt];
}

#pragma mark ***Actions

- (void) stepTimeTextFieldAction:(id)sender
{
	[model setStepTime:[sender floatValue]];	
}

- (void) overshootTextFieldAction:(id)sender
{
	[model setOvershoot:[sender floatValue]];	
}

- (void) decayTimeTextFieldAction:(id)sender
{
	[model setDecayTime:[sender floatValue]];	
}

- (void) decayRateTextFieldAction:(id)sender
{
	[model setDecayRate:[sender floatValue]];	
}

- (void) excursionTextFieldAction:(id)sender
{
	[model setExcursion:[sender floatValue]];	
}

- (IBAction) viewTypeAction:(id)sender
{
    [model setViewType:(int)[[viewTypeMatrix selectedCell] tag]];
}


- (IBAction) millimetersPerVoltTextFieldAction:(id)sender
{
	[model setMillimetersPerVolt:[sender floatValue]];	
}

- (IBAction) chanMatrixAction:(id)sender
{
	if([[sender selectedCell] tag]==0)[model setChanX:[sender intValue]];
	else [model setChanY:[sender intValue]];	
}

- (IBAction) lockAction:(id) sender
{
    [gSecurity tryToSetLock:OReGunLock to:[sender intValue] forWindow:[self window]];
}

- (IBAction) getPositionAction:(id)sender
{
	[model getPosition];
	[xyPlot setNeedsDisplay:YES];
	[xPositionField setNeedsDisplay:YES];
	[yPositionField setNeedsDisplay:YES];
}

- (IBAction) cmdPositionAction:(id)sender
{
	float millimetersPerVolt = [model millimetersPerVolt];
    [model setCmdPosition:NSMakePoint([[cmdMatrix cellWithTag:0] floatValue]/millimetersPerVolt,[[cmdMatrix cellWithTag:1] floatValue]/millimetersPerVolt)];
}

- (IBAction) absMotionAction:(id)sender
{
    [model setAbsMotion:[[absMatrix selectedCell] tag]];
}

- (IBAction) goAction:(id)sender
{
    [self endEditing];
    [model go];
	if([model absMotion])NSLog(@"XY Scanner %d sent to X: %f Y: %f\n",[model uniqueIdNumber],[[cmdMatrix cellWithTag:0] floatValue],[[cmdMatrix cellWithTag:1] floatValue]);
	else NSLog(@"XY Scanner %d moved relative amount X: %f Y: %f\n",[model uniqueIdNumber],[[cmdMatrix cellWithTag:0] floatValue],[[cmdMatrix cellWithTag:1] floatValue]);
}

- (IBAction) stopAction:(id)sender
{
    [model stopMotion];
}

- (IBAction) interfaceObjPUAction:(id)sender
{
	if(sender == interfaceObjPUx){
		[[model x220Object] useProxyObjectWithName:[sender titleOfSelectedItem]];
	}
	else if(sender == interfaceObjPUy){
		[[model y220Object] useProxyObjectWithName:[sender titleOfSelectedItem]];
	}
}

- (IBAction) degaussAction:(id)sender
{
	[model degauss];
}

#pragma mark ***Plotter delegate methods
- (int)	numberPointsInPlot:(id)aPlotter
{
    return (int)[model validTrackCount];
}

- (void) plotter:(id)aPlotter index:(unsigned long)index x:(double*)xValue y:(double*)yValue
{
	float millimetersPerVolt = [model millimetersPerVolt];
    if(index>kNumTrackPoints){
        *xValue = 0;
        *yValue = 0;
		return;
    }
    NSPoint track = [model track:index];
    *xValue = track.x*millimetersPerVolt;
    *yValue = track.y*millimetersPerVolt;
}

- (BOOL) plotter:(id)aPlotter crossHairX:(double*)xValue crossHairY:(double*)yValue
{
	float millimetersPerVolt = [model millimetersPerVolt];
	NSPoint voltage = [model xyVoltage];
    *xValue = voltage.x*millimetersPerVolt;
    *yValue = voltage.y*millimetersPerVolt;
    return YES;
}

@end

