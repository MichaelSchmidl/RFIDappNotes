//
//  ViewController.m
//  simpleReaderApp
//
//  Created by Michael Schmidl on 16.10.14.
//  Copyright (c) 2014 Your Name. All rights reserved.
//

#import "ViewController.h"
#import "EADSessionController.h"

@interface ViewController ()

@end

@implementation ViewController

// used to communicate with the RFID reader
EADSessionController *sessionController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // regigister notifications so we know the accessory connects, disconnects or sent data
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    // first action after start of the application is to check wether a reader is connected
    [self searchForReader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// helper functions for the reader communication
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)searchForReader{
    
    sessionController = [EADSessionController sharedController];
    _accessoryList = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    if ([_accessoryList count] > 0)
    {
        _selectedAccessory = [_accessoryList objectAtIndex:0];
        NSLog(@"open reader communication");
        [sessionController setupControllerForAccessory:_selectedAccessory withProtocolString:@"com.rfideas.reader"];
        if (TRUE == [sessionController openSession])
        {
            [self turnReaderOFF];
        }
        else
        {
            NSLog(@"failed to openSession");
        }
    }
    else
    {
        NSLog(@"no reader found");
    }
}

- (void)turnReaderOFF{
    NSLog(@"turnReaderOFF");

    // send the OFF command to the reader
    [[EADSessionController sharedController] writeData:[@"OFF" dataUsingEncoding:NSUTF8StringEncoding]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// now we implement methods to handle the three accessory notifications
///////////////////////////////////////////////////////////////////////////////////////////////////
// Data was received from the accessory
- (void)_sessionDataReceived:(NSNotification *)notification
{
    
    EADSessionController *sessionController = (EADSessionController *)[notification object];
    NSInteger bytesAvailable = 0;
    
    while ((bytesAvailable = [sessionController readBytesAvailable]) > 0) {
        NSData *data = [sessionController readData:bytesAvailable];
        if (data) {
            NSLog(@"sessionDataReceived:%@", data);
        }
    }
}

// accessory got connected
- (void)_accessoryDidConnect:(NSNotification *)notification {
    NSLog(@"accessoryDidConnect");
}

// accessory disappeared
- (void)_accessoryDidDisconnect:(NSNotification *)notification {
    NSLog(@"accessoryGotLost");
}


@end
