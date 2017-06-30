KJMachPortServer
================

This is a simple example of using NSMachPort for interprocess communication between a client and a server.

Example use:

    xcodebuild -alltargets
    build/Release/KJMachPortServer &     # start server in background
    build/Release/KJMachPortClient       # send a Notify message to server
    build/Release/KJMachPortClient echo  # send Echo and wait for response
    build/Release/KJMachPortClient exit  # send Exit message, and server terminates

