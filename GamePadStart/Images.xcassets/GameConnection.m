//
//  GameConnection.m
//  GamePadStart
//
//  Created by Jake Saferstein on 10/24/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "GameConnection.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "ControllerViewController.h"

@implementation GameConnection

-(id) initWithSock:(GCDAsyncSocket *)sock {
    if(self = [super init]){
        _socket = sock;
        _allData = [[NSMutableData alloc] init];
    }
    return self;
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    while (YES)
    {
        [_allData appendData:data];
        data = [NSData data];
        const char * temp = [_allData bytes];
        int zeroIndex = -1;
        for (int x = 0; x < _allData.length; x++) {
            if(!temp[x])
            {
                zeroIndex = x;
                break;
            }
        }
        if (zeroIndex < 0) break;
        
        /* Operate on buffer w/ zero at zeroIndex */
        NSData* tempData = [_allData subdataWithRange:NSMakeRange(0, zeroIndex)];
        
        /* Process tempdata */
        [self processData:tempData];
        
        /* resp reset */
        _allData = [NSMutableData dataWithData:[_allData subdataWithRange:NSMakeRange(zeroIndex+1, _allData.length - zeroIndex - 1)]];
    }
    
    [_socket readDataWithTimeout:-1 tag:0];
}

-(NSData *)toJSON: (NSDictionary *)dic
{
    NSMutableData* json = [NSMutableData data];
    NSError* err;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        // Serialize the dictionary
        [json appendData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:&err]];
        
        // If no errors, let's view the JSON
        if (json != nil && err == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
//            NSLog(@"JSON: %@", jsonString);
            
            char end = 0;
            
            [json appendBytes:&end length:1];
            return json;
        }
    }
    return nil;
}

-(void)processData: (NSData*) toProc
{
    if(toProc.length <= 1)
        return;
    
    NSDictionary* temp = [NSJSONSerialization JSONObjectWithData:toProc options:NSJSONReadingAllowFragments error:nil];
    
    //If its a request...
    

    
    if (temp[@"op"]) {
        
        //If it is a Game Refresh Request...
        if ([(NSNumber *) temp[@"op"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            _game = temp[@"game"];
            NSMutableDictionary* resp = [[NSMutableDictionary alloc] initWithCapacity:1];
            NSMutableDictionary* sts = [[NSMutableDictionary alloc] initWithCapacity:2];
            resp[@"sts"] = sts;
            sts[@"code"] = [[NSNumber alloc] initWithInt:200];
            sts[@"msg"] = @"Updated game status";
            
            
            /*Reload tabledata*/
            [[SocketManager manager].gamesViewController.tableView reloadData];
            
            [_socket writeData:[self toJSON:resp] withTimeout:-1 tag:4];
            return;
        }
        
        //If it is a Disconnect Request...
        
        NSString* x = [[NSString alloc] initWithFormat:@"%@", temp[@"sts"][@"msg"]];
        
        if ([(NSNumber *) temp[@"op"] isEqualToNumber:[NSNumber numberWithInt:3]]) {
            [UIAlertView bk_showAlertViewWithTitle:@"Disconnected by  Server" message:x cancelButtonTitle:@"Okay" otherButtonTitles:nil
                                handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                    NSLog(@"Disconnected by server alert showed");
                                    /** Go back to discovery*/
                                    [[ControllerViewController sharedInstance] disconnected:nil];
            }];
            
            [[SocketManager manager] disconnectAll];

            
            
            return;
        }
 
        //If it is a Update Pad Config Request...
        if ([(NSNumber *) temp[@"op"] isEqualToNumber:[NSNumber numberWithInt:4]]) {
            _padconfig = temp[@"padconfig"];

            [ControllerViewController sharedInstance].controls =  [NSMutableDictionary dictionary];
            [[ControllerViewController sharedInstance] loadControls];
            
            NSMutableDictionary* resp = [[NSMutableDictionary alloc] initWithCapacity:1];
            NSMutableDictionary* sts = [[NSMutableDictionary alloc] initWithCapacity:2];
            resp[@"sts"] = sts;
            sts[@"code"] = [[NSNumber alloc] initWithInt:200];
            sts[@"msg"] = @"Updated pad config";
    
            [_socket writeData:[self toJSON:resp] withTimeout:-1 tag:4];
            return;
        }
    }
    
    //If its a response...
    else if (temp[@"sts"]) {
        
        //If its a discovery response
        if(temp[@"game"])
        {
            _sts = temp[@"sts"];
            _game = temp[@"game"];
            _banned = temp[@"banned"];
            
            
            [[SocketManager manager].gamesViewController.tableView reloadData];
            
            [[SocketManager manager].gamesViewController.refreshControl endRefreshing];

            return;
        }
        
        //If its a join response
        if(temp[@"accepted"])
        {
            bool accepted = temp[@"accepted"];
            if(!accepted)
            {
                NSLog(@"THIS DUDE IS LITERALLY CHRISTIAN YOU SHOUDL PROBABLY PROCESSS PEOPLE WHO ARE BANNED");
            }
            _padconfig = temp[@"padconfig"];
            [[ControllerViewController sharedInstance] loadControls];
        }
    }
    else
    {
        NSLog(@"Something went wrong processing data");
    }
}

-(void)sendRequest: (Request *)r
{
    [_socket writeData:[r serializeToJSON] withTimeout:-1 tag:0];
}

@end
