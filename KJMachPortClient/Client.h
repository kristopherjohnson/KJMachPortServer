//
//  Client.h
//  KJMachPortServer
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject

- (void)sendNotifyMessage;

- (void)sendExitMessage;

- (void)sendEchoMessage:(NSString *)string;

@end
