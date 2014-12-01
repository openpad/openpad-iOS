//
//  DPadControl.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/11/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "DPadControl.h"

#import "ControllerViewController.h"

@implementation DPadControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)load:(NSDictionary *)data withParentView: (UIView*) parent{
    [super load:data withParentView:parent];
    
    _upImg = [UIImage imageNamed:@"Dpad.png"];
    _upImgView = [[UIImageView alloc] initWithImage:_upImg];
    _upImgView.frame = self.bounds;
    
    [self addSubview:_upImgView];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:1];
    
    CGPoint loc = [[touches anyObject] locationInView:self];
    float x = loc.x / (float) self.bounds.size.width;
    float y = loc.y / (float) self.bounds.size.height;
    
    float sendX = 0;
    float sendY = 0;
    
    if(x > .666)
        sendX = 1;
    else if(x > .333)
        sendX = 0;
    else
        sendX = -1;
    
    if(y > .666)
        sendY = -1;
    else if(y > .333)
        sendY = 0;
    else
        sendY = 1;
    
    /** Send -1,0,1 for both x and y*/
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:sendX], @"y": [NSNumber numberWithFloat:sendY]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    _prevX = sendX;
    _prevY = sendY;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:0];
    
    CGPoint loc = [[touches anyObject] locationInView:self];
    float x = loc.x / (float) self.bounds.size.width;
    float y = loc.y / (float) self.bounds.size.height;
    
    int sendX, sendY;
    
    if(x > .666)
        sendX = 1;
    else if(x > .333)
        sendX = 0;
    else
        sendX = -1;
    
    if(y > .666)
        sendY = -1;
    else if(y > .333)
        sendY = 0;
    else
        sendY = 1;
    
    /** Send -1,0,1 for both x and y*/
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:sendX], @"y": [NSNumber numberWithFloat:sendY]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    _prevX = sendX;
    _prevY = sendY;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:2];
    
    CGPoint loc = [[touches anyObject] locationInView:self];
    float x = loc.x / (float) self.bounds.size.width;
    float y = loc.y / (float) self.bounds.size.height;
    
    int sendX, sendY;
    
    if(x > .666)
        sendX = 1;
    else if(x > .333)
        sendX = 0;
    else
        sendX = -1;
    
    if(y > .666)
        sendY = -1;
    else if(y > .333)
        sendY = 0;
    else
        sendY = 1;
    
    /** Touch didn't change button*/
    if(sendY == _prevY && sendX == _prevX)
    {
        return;
    }
    
    /** Send -1,0,1 for both x and y*/
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:sendX], @"y": [NSNumber numberWithFloat:sendY]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    _prevX = sendX;
    _prevY = sendY;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
