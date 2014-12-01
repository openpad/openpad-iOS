//
//  DPadControl.h
//  GamePadStart
//
//  Created by Jake Saferstein on 11/11/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "ControlObj.h"
#import "ControllerViewController.h"


@interface DPadControl : ControlObj


@property (nonatomic) UIImage* upImg;
@property (nonatomic) UIImageView* upImgView;

@property (nonatomic) float prevX;
@property (nonatomic) float prevY;

@end
