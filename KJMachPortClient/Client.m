//
//  Client.m
//  KJMachPortServer
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#import "Client.h"
#import "ServerProtocol.h"

@implementation Client

- (NSPort *)serverPort {
    return [[NSMachBootstrapServer sharedInstance]
            portForName:SERVER_NAME];
}

- (void)sendNotifyMessage {
    NSPort *port = [self serverPort];
    if (port == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:port
                              receivePort:nil
                              components:nil];
    message.msgid = ServerMsgIdNotify;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

- (void)sendExitMessage {
    NSPort *port = [self serverPort];
    if (port == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:port
                              receivePort:nil
                              components:nil];
    message.msgid = ServerMsgIdExit;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

@end
