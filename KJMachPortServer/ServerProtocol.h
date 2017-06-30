//
//  ServerProtocol.h
//  KJMachPortServer
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#ifndef ServerProtocol_h
#define ServerProtocol_h

// Definitions shared between Server and its clients.

#define SERVER_NAME @"net.kristopherjohnson.KJMachPortServer"

typedef NS_ENUM(uint32_t, ServerMsgId) {
    ServerMsgIdNotify = 1,
    ServerMsgIdExit = 2,
    ServerMsgIdEcho = 3
};

#endif /* ServerProtocol_h */
