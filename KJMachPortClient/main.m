//
//  main.m
//  KJMachPortClient
//
//  Created by Kristopher Johnson on 6/29/17.
//  Copyright © 2017 Kristopher Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Client *client = [Client new];
        if (argc > 1 && strcmp("exit", argv[1]) == 0) {
            [client sendExitMessage];
        }
        if (argc > 1 && strcmp("echo", argv[1]) == 0) {
            [client sendEchoMessage:@"Test Data"];
        }
        else {
            [client sendNotifyMessage];
        }
    }
    return 0;
}
