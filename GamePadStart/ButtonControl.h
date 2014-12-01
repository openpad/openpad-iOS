//
//  ButtonControl.h
//  GamePadStart
//
//  Created by Jake Saferstein on 11/10/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "ControlObj.h"
#import "ControllerViewController.h"


@interface ButtonControl : ControlObj

-(id)init;


@property (nonatomic) UIImage* upImg;
@property (nonatomic) UIImage* downImg;

@property (nonatomic) UIImageView* upImgView;
@property (nonatomic) UIImageView* downImgView;

@end
