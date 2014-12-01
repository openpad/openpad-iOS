//
//  ControlObj.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/10/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//


#import "ControllerViewController.h"
#import "ControlObj.h"

@implementation ControlObj

-(void)load:(NSDictionary *)data withParentView:(UIView *)parent{
    _type = [data[@"type"] intValue];
    _idNum = [data[@"id"] intValue];
    
    CGSize bounds = parent.frame.size;
    NSDictionary* frame = data[@"frame"];
    float x = [frame[@"x"] floatValue] * bounds.width;
    float y = [frame[@"y"] floatValue] * bounds.height;
    float w = [frame[@"w"] floatValue] * bounds.width;
    float h = [frame[@"h"] floatValue] * bounds.height;
    self.frame = CGRectMake(x - (MIN(w, h)/2), y - (MIN(w,h)/2), MIN(w,h), MIN(w,h)); /** Ensures button is a square w/ coords at center*/
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event]; /** Pretty sure you're supposed to do this*/
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event]; /** Pretty sure you're supposed to do this*/
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event]; /** Pretty sure you're supposed to do this*/
}

@end