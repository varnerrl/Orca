//--------------------------------------------------------
// ORSerialPortModel
// Created by Mark  A. Howe on Wed 4/15/2009
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

#pragma mark •••Imported Files
@class ORSerialPort;

@interface ORSerialPortModel : OrcaObject
{
    @protected
        NSString*			portName;
        BOOL				portWasOpen;
        ORSerialPort*		serialPort;
 }

#pragma mark •••Initialization
- (void) registerNotificationObservers;

#pragma mark •••Accessors
- (ORSerialPort*) serialPort;
- (void) setSerialPort:(ORSerialPort*)aSerialPort;
- (BOOL) portWasOpen;
- (void) setPortWasOpen:(BOOL)aPortWasOpen;
- (NSString*) portName;
- (void) setPortName:(NSString*)aPortName;
- (void) openPortIfNeeded;

#pragma mark •••Archival
- (id)   initWithCoder:(NSCoder*)decoder;
- (void) encodeWithCoder:(NSCoder*)encoder;

#pragma mark •••Port Methods
- (void) serialPortWriteProgress:(NSDictionary *)dataDictionary;
- (void) openPort:(BOOL)aState;
- (void) portsChanged:(NSNotification*)aNote;
- (void) dataReceived:(NSNotification*)aNote;
@end

extern NSString* ORSerialPortModelSerialPortChanged;
extern NSString* ORSerialPortModelPortNameChanged;
extern NSString* ORSerialPortModelPortStateChanged;
extern NSString* ORSerialPortModelSerialListChanged;

