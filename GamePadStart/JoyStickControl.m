//
//  DPadControl.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/11/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "JoyStickControl.h"

#import "ControllerViewController.h"

@implementation JoyStickControl

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
    
    _upImg = [UIImage imageNamed:@"Circle.png"];
    _upImgView = [[UIImageView alloc] initWithImage:_upImg];
    _upImgView.frame = self.bounds;
    
    [self addSubview:_upImgView];
    
    _stickImg = [UIImage imageNamed:@"Knob.png"];
    _stickImgView = [[UIImageView alloc] initWithImage:_stickImg];
    int temp = self.bounds.size.width;
    _stickImgView.frame = CGRectMake(temp/2 - temp/4, temp/2 - temp/4, temp/2, temp/2);
    
    [self addSubview:_stickImgView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    /** Send request */
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:1];
    
    
    
    /** Animate! */
    CGPoint temp = [[touches anyObject] locationInView:self];
    
    
    float locX = temp.x / (double)  self.frame.size.width;
    float locY = temp.y / (double) self.frame.size.height;
    locX -= .5;
    locY -= .5;
    
    locY *= 2; ///Make Y negative so bottom is negative top is postive
    locX *= 2;
    
    float dist = sqrtf(  locX*locX + locY*locY   );
    float theta = atan2f(locY, locX);
    if(dist > 1)
    {
        dist = 1;
        locX = dist*cosf(theta);
        locY = dist*sinf(theta);
        
        temp.x = ((locX + 1)/2.0)*self.frame.size.width;
        temp.y = ((locY + 1)/2.0)*self.frame.size.height;
    }
    
    locY *= -1;
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:locX], @"y": [NSNumber numberWithFloat:locY]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    _stickImgView.frame = CGRectMake(temp.x - self.bounds.size.width/4, temp.y - self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
}

#warning Radially inward shadow maybe????!??!??
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    /** Send request */
//    Request* r = [[Request alloc] initWithOp:5];
//    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
//    r.data[@"action"] = [NSNumber numberWithInt:1];
//    
//    
//    
//    /** Animate! */
//    CGPoint temp = [[touches anyObject] locationInView:self];
//    
//    int x, y;
//    
//    NSLog(@"%i, %i", x, y);
//    
//    if(temp.x < 0)
//    {
//        x = 0;
//    }
//    else if(temp.x > self.bounds.size.width)
//    {
//        x = self.bounds.size.width;
//    }
//    else
//    {
//        x= temp.x;
//    }
//    
//    if(temp.y < 0)
//    {
//        y = 0 ;
//    }
//    else if(temp.y > self.bounds.size.height)
//    {
//        y = self.bounds.size.height;
//    }
//    else
//    {
//        y= temp.y;
//    }
//    
//    float locX = x / (double)  self.frame.size.width;
//    float locY = y / (double) self.frame.size.height;
//    locX -= .5;
//    locY -= .5;
//    
//    locY *= -1;
//    
//    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:locX], @"y": [NSNumber numberWithFloat:locY]};
//    
//    [[ControllerViewController sharedInstance].game sendRequest:r];
//
//    
//
//    _stickImgView.frame = CGRectMake(x - self.bounds.size.width/4, y - self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
//}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    /** Send request */
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:0];
    
    CGPoint loc = [[touches anyObject] locationInView:self];
    float locX = loc.x / (double) self.frame.size.width;
    float locY = loc.y / (double) self.frame.size.height;
    
    locY *= -1;

    
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:(locX-.5)], @"y": [NSNumber numberWithFloat:(locY-.5)]};
    
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    int temp = self.bounds.size.width;
    _stickImgView.frame = CGRectMake(temp/2 - temp/4, temp/2 - temp/4, temp/2, temp/2); ///Center the control
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /** Send request */
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:2];

    
    /** Animate! */
    CGPoint temp = [[touches anyObject] locationInView:self];
    
    
    float locX = temp.x / (double)  self.frame.size.width;
    float locY = temp.y / (double) self.frame.size.height;
    locX -= .5;
    locY -= .5;
    
    locY *= 2; ///Make Y negative so bottom is negative top is postive
    locX *= 2;
    
    float dist = sqrtf(  locX*locX + locY*locY   );
    float theta = atan2f(locY, locX);
    if(dist > 1)
    {
        dist = 1;
        locX = dist*cosf(theta);
        locY = dist*sinf(theta);
        
        temp.x = ((locX + 1)/2.0)*self.frame.size.width;
        temp.y = ((locY + 1)/2.0)*self.frame.size.height;
    }
    
    NSLog(@"Phys Locs: %f, %f", temp.x, temp.y);
    NSLog(@"LocX,Y: %f, %f", locX, locY);

    
    locY *= -1;
    
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:locX], @"y": [NSNumber numberWithFloat:locY]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
    
    _stickImgView.frame = CGRectMake(temp.x - self.bounds.size.width/4, temp.y - self.bounds.size.height/4, self.bounds.size.width/2, self.bounds.size.height/2);
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
