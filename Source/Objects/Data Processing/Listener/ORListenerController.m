//--------------------------------------------------------
// ORListenerController
// Created by Mark  A. Howe on Mon Apr 11 2005
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

#import "ORListenerController.h"
#import "ORListenerModel.h"

@implementation ORListenerController

#pragma mark ***Initialization

- (id) init
{
	self = [super initWithWindowNibName:@"Listener"];
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark ***Notifications

- (void) registerNotificationObservers
{
	NSNotificationCenter* notifyCenter = [NSNotificationCenter defaultCenter];
    [super registerNotificationObservers];
    
    [notifyCenter addObserver : self
                     selector : @selector(lockChanged:)
                         name : ORListenerLock
                       object : nil];
    
	[notifyCenter addObserver : self
                      selector: @selector(remotePortChanged:)
                          name: ORListenerRemotePortChanged
                       object : model];
    
	[notifyCenter addObserver : self
                      selector: @selector(remoteHostChanged:)
                          name: ORListenerRemoteHostChanged
                       object : model];
    
	[notifyCenter addObserver : self
                      selector: @selector(isConnectedChanged:)
                          name: ORListenerIsConnectedChanged
                       object : model];
    
	[notifyCenter addObserver : self
                      selector: @selector(byteCountChanged:)
                          name: ORListenerByteCountChanged
                       object : model];
    
	[notifyCenter addObserver : self
                      selector: @selector(connectAtStartChanged:)
                          name: ORListenerConnectAtStartChanged
                       object : [self model]];
    
	[notifyCenter addObserver : self
                      selector: @selector(autoReconnectChanged:)
                          name: ORListenerAutoReconnectChanged
                       object : [self model]];	
}

- (void) updateWindow
{
    [super updateWindow];
	[self remotePortChanged:nil];
	[self remoteHostChanged:nil];
	[self isConnectedChanged:nil];
	[self byteCountChanged:nil];
	[self connectAtStartChanged:nil];
	[self autoReconnectChanged:nil];
	
}

- (void) connectAtStartChanged:(NSNotification*)aNote
{
	[connectAtStartButton setState:[model connectAtStart]];
}

- (void) autoReconnectChanged:(NSNotification*)aNote
{
	[autoReconnectButton setState:[model autoReconnect]];
}


- (void) remotePortChanged:(NSNotification*)aNote
{
    // the check below is to avoid warnings with mulitple classes implementing remotePort and different return types
    if([[model className] isEqualToString:@"ORListenerModel"])
        [remotePortField setIntValue:[(ORListenerModel*)model remotePort]];
}

- (void) remoteHostChanged:(NSNotification*)aNote
{
	[remoteHostField setStringValue:[model remoteHost]];
}

- (void) isConnectedChanged:(NSNotification*)aNote
{
	[connectionStatusField setStringValue:[model isConnected]?@"Connected":@"---"];
	[connectButton setTitle:[model isConnected]?@"Disconnect":@"Connect"];
}

- (void) byteCountChanged:(NSNotification*)aNote
{
	[byteRecievedField setIntegerValue:[model byteCount]];
}

- (void) lockChanged:(NSNotification*)aNotification
{
    BOOL locked = [gSecurity isLocked:ORListenerLock];
    [lockButton setState: locked];
    
    [remotePortField setEnabled:!locked];
    [remoteHostField setEnabled:!locked];
    [connectAtStartButton setEnabled:!locked];
    [autoReconnectButton setEnabled:!locked];
}


#pragma mark ***Actions

- (void) checkGlobalSecurity
{
    BOOL secure = [gSecurity globalSecurityEnabled];
    [gSecurity setLock:ORListenerLock to:secure];
    [lockButton setEnabled:secure];
}

- (IBAction) lockAction:(id)sender
{
    [gSecurity tryToSetLock:ORListenerLock to:[sender intValue] forWindow:[self window]];
}

- (IBAction) remotePortFieldAction:(id)sender
{
	[model setRemotePort:[sender intValue]];
}

- (IBAction) remoteHostFieldAction:(id)sender
{
	[model setRemoteHost:[sender stringValue]];
}


- (IBAction) connectButtonAction:(id)sender
{
	[self endEditing];
    if([model isConnected]){
        [model connectSocket:NO];
    }
    else {
        [model connectSocket:YES];
    }
}

- (IBAction) connectAtStartAction:(id)sender
{
	[[self model] setConnectAtStart:[sender state]];
}

- (IBAction) autoReconnectAction:(id)sender
{
	[[self model] setAutoReconnect:[sender state]];
}


@end

