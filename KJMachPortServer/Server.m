//
//  Server.m
//  KJMachPortServer
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#import "Server.h"
#import "ServerProtocol.h"

@interface Server () <NSPortDelegate>
@property NSPort *port;
@end

@implementation Server

- (void)run {
    self.port = [[NSMachBootstrapServer sharedInstance]
                 servicePortWithName:SERVER_NAME];
    if (self.port == nil) {
        // This probably means another instance is running.
        NSLog(@"Unable to open server port.");
        return;
    }

    self.port.delegate = self;

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

    [runLoop addPort:self.port forMode:NSDefaultRunLoopMode];

    NSLog(@"Server running");
    [runLoop run];
    NSLog(@"Server exiting");
}

- (void)handlePortMessage:(NSPortMessage *)message {
    switch (message.msgid) {
        case ServerMsgIdNotify:
            NSLog(@"Received Notify message");
            break;

        case ServerMsgIdExit:
            NSLog(@"Received Exit message");
            exit(0);
            break;

        case ServerMsgIdEcho: {
            NSPort *responsePort = message.sendPort;
            if (responsePort != nil) {
                NSArray *components = message.components;
                if (components.count > 0) {
                    NSString *dataString = [[NSString alloc]
                                            initWithData:components[0]
                                            encoding:NSUTF8StringEncoding];
                    NSLog(@"Received echo request: \"%@\"", dataString);
                }
                NSPortMessage *response = [[NSPortMessage alloc]
                                           initWithSendPort:responsePort
                                           receivePort:nil
                                           components:message.components];
                response.msgid = message.msgid;
                NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:5.0];
                [response sendBeforeDate:timeout];
                NSLog(@"Sent echo response");
            }
        } break;

        default:
            NSLog(@"Unexpected message ID %u", (unsigned)message.msgid);
            break;
    }
}

@end
