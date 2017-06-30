//
//  Client.m
//  KJMachPortServer
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#import "Client.h"
#import "ServerProtocol.h"

@interface Client () <NSPortDelegate>
@end

@implementation Client {
    BOOL _responseReceived;
}

- (NSPort *)serverPort {
    return [[NSMachBootstrapServer sharedInstance]
            portForName:SERVER_NAME];
}

- (void)sendNotifyMessage {
    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:sendPort
                              receivePort:nil
                              components:nil];
    message.msgid = ServerMsgIdNotify;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

- (void)sendExitMessage {
    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:sendPort
                              receivePort:nil
                              components:nil];
    message.msgid = ServerMsgIdExit;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }
}

- (void)sendEchoMessage:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSPort *sendPort = [self serverPort];
    if (sendPort == nil) {
        NSLog(@"Unable to connect to server port");
        return;
    }

    NSPort *receivePort = [NSMachPort port];
    receivePort.delegate = self;

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:receivePort forMode:NSDefaultRunLoopMode];

    NSPortMessage *message = [[NSPortMessage alloc]
                              initWithSendPort:sendPort
                              receivePort:receivePort
                              components:@[data]];
    message.msgid = ServerMsgIdEcho;

    _responseReceived = NO;

    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
    if (![message sendBeforeDate:timeout]) {
        NSLog(@"Send failed");
    }

    while (!_responseReceived) {
        [runLoop runUntilDate:
         [NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

- (void)handlePortMessage:(NSPortMessage *)message {
    switch (message.msgid) {
        case ServerMsgIdEcho: {
            NSArray *components = message.components;
            if (components.count > 0) {
                NSString *dataString = [[NSString alloc]
                                        initWithData:components[0]
                                        encoding:NSUTF8StringEncoding];
                NSLog(@"Received Echo response: \"%@\"", dataString);
            }
        } break;

        default:
            NSLog(@"Unexpected response msgid %u",
                  (unsigned)message.msgid);
            break;
    }
    
    _responseReceived = YES;
}

@end
