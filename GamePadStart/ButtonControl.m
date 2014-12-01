//
//  ButtonControl.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/10/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "ButtonControl.h"
#import "Request.h"

@implementation ButtonControl

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)load:(NSDictionary *)data withParentView: (UIView*) parent{
    [super load:data withParentView:parent];
    
    int temp = [data[@"btntype"] intValue];
    switch (temp) {
        case 0:
            _upImg = [UIImage imageNamed:@"A_UP.png"];
            _downImg = [UIImage imageNamed:@"A_DOWN.png"];
            break;
        case 1:
            _upImg = [UIImage imageNamed:@"B_UP.png"];
            _downImg = [UIImage imageNamed:@"B_DOWN.png"];
            break;
        case 2:
            _upImg = [UIImage imageNamed:@"X_UP.png"];
            _downImg = [UIImage imageNamed:@"X_DOWN.png"];
            break;
        case 3:
            _upImg = [UIImage imageNamed:@"Y_UP.png"];
            _downImg = [UIImage imageNamed:@"Y_DOWN.png"];
            break;
    }
    
    _upImgView = [[UIImageView alloc] initWithImage:_upImg];
    _downImgView = [[UIImageView alloc] initWithImage:_downImg];
    
    _upImgView.frame = self.bounds;
    _downImgView.frame = self.bounds;

    [self addSubview:_downImgView];
    [self addSubview:_upImgView];
    [_downImgView setHidden:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [_downImgView setHidden:NO];
    [_upImgView setHidden:YES];
    
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:1];
    
    
    /** Send -1 for positions of a button*/
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:-1], @"y": [NSNumber numberWithFloat:-1]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [_downImgView setHidden:YES];
    [_upImgView setHidden:NO];
    
    Request* r = [[Request alloc] initWithOp:5];
    r.data[@"controlid"] = [NSNumber numberWithInt:self.idNum];
    r.data[@"action"] = [NSNumber numberWithInt:0];
    
    /** Send -1 for positions of a button */
    r.data[@"position"] = @{@"x": [NSNumber numberWithFloat:-1], @"y": [NSNumber numberWithFloat:-1]};
    
    [[ControllerViewController sharedInstance].game sendRequest:r];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**Do nothing on moving for buttons*/
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
