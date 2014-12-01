//
//  DPadControl.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/11/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "StaticControl.h"

#import "ControllerViewController.h"

@implementation StaticControl

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
    
    NSData* imgData = [NSData dataWithBase64EncodedString:data[@"img"]];
    _img = [[UIImage alloc] initWithData:imgData];
    _imgView = [[UIImageView alloc] initWithImage:_img];
    _imgView.frame = self.bounds;
    
    [self addSubview:_imgView];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**Do nothing*/
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**Do nothing*/
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /**Do nothing*/
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
