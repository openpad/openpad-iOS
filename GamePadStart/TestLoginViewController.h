//
//  TestLoginViewController.h
//  GamePadStart
//
//  Created by Jake Saferstein on 10/21/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserData.h"
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>


@interface TestLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic) UIView* fgView;

@property (nonatomic) UIImageView* logo;
@property (nonatomic) UILabel* openPad;
@property (nonatomic) UITextField* firstName;
@property (nonatomic) UITextField* lastName;
@property (nonatomic) UITextField* username;
@property (nonatomic) UIButton* submit;


@property UIImageView* bgView;


@end
