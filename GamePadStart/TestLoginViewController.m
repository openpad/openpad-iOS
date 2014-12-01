//
//  TestLoginViewController.m
//  GamePadStart
//
//  Created by Jake Saferstein on 10/21/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "TestLoginViewController.h"
#import "GameListViewController.h"
#import "BackgroundLayer.h"
#import "SocketManager.h"
#import  <pop/POP.h>


@implementation UINavigationController (DUMBROTATIONFIX)

-(BOOL)shouldAutorotate
{
    return YES;[[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

@interface TestLoginViewController ()

@end

@implementation TestLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"User Info";
    }
    return self;
}


-(void)dismissKeyboard {
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_username resignFirstResponder];
    NSMutableDictionary* temp = [UserData getUserData];
    temp[@"username"] = _username.text;
    temp[@"firstname"] = _firstName.text;
    temp[@"lastname"] = _lastName.text;
}

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    /** Set up the foreground box to fit the screen */
    _fgView = [[UIView alloc] initWithFrame:CGRectMake(40, 80,  WIDTH - 80, HEIGHT - 216 - 54)];
    _fgView.backgroundColor = [UIColor clearColor];
    
    _fgView.layer.masksToBounds = NO;
    _fgView.layer.cornerRadius = 8; // if you like rounded corners
    _fgView.layer.shadowOffset = CGSizeMake(0,0);
    _fgView.layer.shadowRadius = 3;
    _fgView.layer.shadowOpacity = 0.5;
    
    
    /** Useful for creating the UI based on the foreground box */
#define FGWIDTH _fgView.bounds.size.width
#define FGHEIGHT _fgView.bounds.size.height
    
//    /** Create the background view */
//    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundTexture.jpg"]];
//    _bgView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    _bgView.frame = self.view.bounds;
//    [self.view addSubview:_bgView];
    self.view.backgroundColor = BLACK;
    
    [self.view addSubview:_fgView];
    
    
    /** Set up fgView */
    UIImage* tempImg = [UIImage imageNamed:@"Logo_Transparent.png"];
    _logo = [[UIImageView alloc] initWithImage:tempImg];
    _logo.frame = CGRectMake(FGWIDTH/2 - FGHEIGHT*3/16, 5, FGHEIGHT*3/8, FGHEIGHT*3/8);
    [_fgView addSubview:_logo];
    
    _openPad = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 + FGHEIGHT*3/8, FGWIDTH, FGHEIGHT/8)];
    _openPad.text = @"{openpad}";
    _openPad.backgroundColor = BLACK;
    _openPad.textAlignment = NSTextAlignmentCenter;
     _openPad.textColor = GREY;
    _openPad.numberOfLines = 1;
    _openPad.font = [UIFont systemFontOfSize:FGHEIGHT/8];
    _openPad.adjustsFontSizeToFitWidth = YES;
//    _openPad.backgroundColor = RED;
    [_fgView addSubview:_openPad];
    
    int newHeight = _openPad.font.pointSize;
    _openPad.frame = CGRectMake(0, 5 + FGHEIGHT/4, FGWIDTH, newHeight);
    
    int highPt = newHeight + FGHEIGHT/4+ 5;

    _firstName = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, highPt + 10, FGWIDTH/2, 20)];
    _lastName = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, highPt + 40, FGWIDTH/2, 20)];
    _username = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, highPt + 70, FGWIDTH/2, 20)];
    
    
    _firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    _lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    _username.autocorrectionType = UITextAutocorrectionTypeNo;

    
    [_firstName setBorderStyle:UITextBorderStyleRoundedRect];
    [_lastName setBorderStyle:UITextBorderStyleRoundedRect];
    [_username setBorderStyle:UITextBorderStyleRoundedRect];
    
    _firstName.textColor = RED;
    _lastName.textColor = RED;
    _username.textColor = RED;
    
    _firstName.delegate = self;
    _lastName.delegate = self;
    _username.delegate = self;

    [_fgView addSubview:_firstName];
    [_fgView addSubview:_lastName];
    [_fgView addSubview:_username];
    
    _submit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _submit.frame = CGRectMake(FGWIDTH/4, highPt + 95, FGWIDTH/2, 20);
    [_submit setTitle:@"Continue" forState:UIControlStateNormal];
    _submit.titleLabel.textColor = GREY;
    [_submit addTarget:self action:@selector(submitted:) forControlEvents:UIControlEventTouchUpInside];
    
    [_fgView addSubview:_submit];
    
    _firstName.placeholder = @"John";
    _lastName.placeholder = @"Doe";
    _username.placeholder = @"XxX_$w@gYo1o420_XxX";
    
    /** Fill the fields */
    NSMutableDictionary* temp = [UserData getUserData];

    if(!temp[@"firstname"])
    {
        _firstName.placeholder = @"John";
    }
    else
    {
        _firstName.text = temp[@"firstname"];
    }
    
    if (!temp[@"lastname"])
    {
        _lastName.placeholder = @"Doe";
    }
    else
    {
        _lastName.text = temp[@"lastname"];
    }
    
    if(!temp[@"username"])
    {
        _username.placeholder = @"XxX_$w@gYo1o420_XxX";
    }
    else
    {
        _username.text = temp[@"username"];
    }
    
    /** Allow user to tap out of text fields */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(![textField.text isEqualToString:@""])
    {
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _submit.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
    }
    else
    {
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        } completion:^(BOOL finished){}];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary* temp = [UserData getUserData];
    temp[@"username"] = _username.text;
    temp[@"firstname"] = _firstName.text;
    temp[@"lastname"] = _lastName.text;
}


-(void)viewDidAppear:(BOOL)animated
{
    
    /** Animate! */
    NSMutableDictionary* temp = [UserData getUserData];

    /** As long as everything exists, animate normally */
    if(temp[@"username"] && temp[@"firstname"] && temp[@"lastname"])
    {
        /** Prepare for animations */
        _fgView.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
        _logo.transform = CGAffineTransformMakeScale(.01, .01);
        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _fgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _logo.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _openPad.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1.25 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _firstName.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1.5 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _lastName.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1.75 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _username.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:2 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _submit.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
    }
    else {
        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        
        _logo.frame = CGRectMake(_logo.frame.origin.x, HEIGHT/2 - (_logo.frame.size.height)*2.5/2, _logo.frame.size.width, _logo.frame.size.height);
        POPSpringAnimation* logoAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        logoAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(.01, .01)];
        logoAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
        logoAnim.velocity = [NSValue valueWithCGPoint:CGPointMake(.005, .005)];
        logoAnim.springBounciness = 20;
        [_logo.layer pop_addAnimation:logoAnim forKey:@"scale"];
        
        logoAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
            NSLog(@"Animation has completed.");
        };
        
//        //_fgView.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
//        _logo.frame = CGRectMake(_logo.frame.origin.x, HEIGHT/2 - _logo.frame.size.height/2 - 80, _logo.frame.size.width, _logo.frame.size.height);
//        _logo.transform = CGAffineTransformMakeScale(.01, .01);
//        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        [UIView animateWithDuration:1 delay:.5 usingSpringWithDamping:.5 initialSpringVelocity:1 options:0 animations:^{
//           _logo.transform = CGAffineTransformMakeScale(2, 2);
//        } completion:^(BOOL finished) { }];
//        [UIView animateWithDuration:1 delay:2 usingSpringWithDamping:.5 initialSpringVelocity:1 options:0 animations:^{
//            _logo.transform = CGAffineTransformMakeTranslation(0, 85 - (HEIGHT/2 - _logo.frame.size.height/2 - 80));
//        } completion:^(BOOL finished) { }];
        
    }
}

-(void)submitted:(UIButton *) button
{
    if(!_firstName.text.length || !_lastName.text.length || !_username.text.length)
    {
        [UIAlertView bk_showAlertViewWithTitle:@"Missing Fields" message:@"Fill in all fields to continue" cancelButtonTitle:@"Try again" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
        return;
    }
    NSMutableDictionary* temp = [UserData getUserData];
    temp[@"username"] = _username.text;
    temp[@"firstname"] = _firstName.text;
    temp[@"lastname"] = _lastName.text;
    NSString *uuid = [[NSUUID UUID] UUIDString];
    temp[@"phoneID"] = uuid;
    temp[@"fbuid"] = @"";

    [SocketManager manager].gamesViewController = [[GameListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:[SocketManager manager].gamesViewController animated:YES];
    [self.navigationController popToViewController:[SocketManager manager].gamesViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
