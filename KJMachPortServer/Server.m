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

        default:
            NSLog(@"Unexpected message ID %u", (unsigned)message.msgid);
            break;
    }
}

@end
