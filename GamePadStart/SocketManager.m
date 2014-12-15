//
//  SocketManager.m
//  GamePadStart
//
//  Created by Jake Saferstein on 10/22/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "SocketManager.h"

#include <ifaddrs.h>
#import "UserData.h"
#include <arpa/inet.h>
#import "ControllerViewController.h"
#include <netinet/in.h>



@implementation SocketManager

static SocketManager* instance;

+(SocketManager*)manager{
    if(!instance){
        instance = [[SocketManager alloc] init];
    }
    return instance;
}

-(id)init{
    if(self = [super init]){
        instance = self;
    }
    return self;
}

-(void)disconnectAll
{
    for (GCDAsyncSocket* temp in _attemptedSockets) {
        [temp disconnect];
    }
    _attemptedSockets = [NSMutableArray array];
    _connections = [NSMutableArray array];
    _addresses = [NSMutableArray array];
}

/** Initial Method: Ping everyone on Wi-Fi to find server IP/Port */
-(void)discoverServers
{
    GCDAsyncUdpSocket* temp = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError* err;
    if(![temp enableBroadcast:YES error:&err]){
//        NSLog(@"error enabling broadcast: %@", err);
    }
    char c = 'a';
    NSData * pingData = [NSData dataWithBytes:&c length:1];
    
    for (int i = 0; i < 10; i++)
    {
        [temp sendData:pingData toHost:@"255.255.255.255" port:9999 withTimeout:-1 tag:0];
    }
    [temp beginReceiving:&err];
    
    
    _rfrshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:_gamesViewController.refreshControl selector:@selector(endRefreshing) userInfo:nil repeats:YES];
}


/** Process UDP Responses */
-(void)udpSocket:(GCDAsyncUdpSocket*)socket didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSLog(@"Received data from %@", address);
    const char* arr = [address bytes];
//    
    for (int x = 0; x < sizeof(arr); x++) {
//        NSLog(@"%x",arr[x]%255);
    }
    
//    struct sockaddr_in ip;
//    ip.sin_family = AF_INET;
//    ip.sin_port = htons(6003);
//    inet_pton(AF_INET, "0.0.0.0", &ip.sin_addr);
//    
//    NSData * discoveryHost = [NSData dataWithBytes:&ip length:ip.sin_len];
    const unsigned char* arr2 = [data bytes];

    int port = (arr2[0])*256+(arr2[1]);

    char addr[100];
    
    int ip1 = arr[4]%256;
    if(arr[4] < 0)
    {
        ip1 = 256 + arr[4];
    }
    
    int ip2 = arr[5]%256;
    if(arr[5] < 0)
    {
        ip2 = 256 + arr[5];
    }
    
    int ip3 = arr[6]%256;
    if(arr[6] < 0)
    {
        ip3 = 256 + arr[6];
    }
    
    int ip4 = arr[7]%256;
    if(arr[7] < 0)
    {
        ip4 = 256 + arr[7];
    }
    
    
    sprintf(addr, "%0i.%0i.%0i.%0i", ip1, ip2, ip3, ip4);
//    NSLog(@"ip = %s, port = %d", addr, port);
    
    [self joinGame:[NSString stringWithUTF8String:addr] onPort:port];

}

/** Connect to games found with UDP using TCP */
-(void) joinGame: (NSString *) ip onPort: (int) port
{
    
    NSString* temp = [NSString stringWithFormat:@"%@:%d", ip, port];
    if(!_addresses)_addresses = [NSMutableArray array];
    if([_addresses containsObject:temp])
    {
        return;
    }
    [_addresses addObject:temp];
    
    GCDAsyncSocket* curSock = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    if(!_attemptedSockets)_attemptedSockets = [NSMutableArray array];

    [self.attemptedSockets addObject:curSock];
        
    NSError *err = nil;
//    NSLog(@"Connecting to address: %@ : %d", ip, port);
    if(![curSock connectToHost:ip onPort:port error:&err])
    {
        NSLog(@"I goofed: %@", err);
    }
}

/** If connected, send data and start to read */
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
//    NSLog(@"A socket connected");
    
    Request* r = [[Request alloc] initWithOp:0];
    
    
    GameConnection* newGame = [[GameConnection alloc] initWithSock:sender];
    [sender setDelegate:newGame];
    
    [sender writeData:[r serializeToJSON] withTimeout:-1 tag:0];

    if(!_connections) _connections = [NSMutableArray array];
    [_connections addObject:newGame];
    
    [sender readDataWithTimeout:-1 tag:0];
    [ControllerViewController sharedInstance].game = nil;
}

@end
