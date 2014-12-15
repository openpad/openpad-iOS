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
//#import <FacebookSDK/FacebookSDK.h>



@implementation UINavigationController (DUMBROTATIONFIX)

-(BOOL)shouldAutorotate
{
    return YES; //[[self.viewControllers lastObject] shouldAutorotate];
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
    
    
    self.view.backgroundColor = BLACK;
    
    /** Set up the foreground box to fit the screen */
    _fgView = [[UIView alloc] initWithFrame:CGRectMake(40, 80,  WIDTH - 80, HEIGHT - 216 - 54)];
    _fgView.backgroundColor = [UIColor clearColor];
    _fgView.layer.masksToBounds = NO;
    _fgView.layer.cornerRadius = 8; // if you like rounded corners
    _fgView.layer.shadowOffset = CGSizeMake(0,0);
    _fgView.layer.shadowRadius = 3;
    _fgView.layer.shadowOpacity = 0.5;
    [self.view addSubview:_fgView];
    
    
    /** Useful for creating the UI based on the foreground box */
#define FGWIDTH _fgView.bounds.size.width
#define FGHEIGHT _fgView.bounds.size.height
    
    
    /** Set up fgView */
    UIImage* tempImg = [UIImage imageNamed:@"Logo_Transparent.png"];
    _logo = [[UIImageView alloc] initWithImage:tempImg];
    
    int hgtConst = FGHEIGHT - 130;
    
    
    _logo.frame = CGRectMake(FGWIDTH/2 - hgtConst*3/8, 5, hgtConst*3/4, hgtConst*3/4);
    [_fgView addSubview:_logo];
    
    _openPad = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 + hgtConst*3/4, FGWIDTH, hgtConst/4)];
    _openPad.text = @"{openpad}";
    _openPad.textAlignment = NSTextAlignmentCenter;
    _openPad.baselineAdjustment = UIBaselineAdjustmentNone;
     _openPad.textColor = GREY;
    _openPad.numberOfLines = 1;
    _openPad.font = [UIFont systemFontOfSize:hgtConst/4 - 5];
    _openPad.layer.masksToBounds = NO;
    _openPad.adjustsFontSizeToFitWidth = YES;
//    _openPad.backgroundColor = DARKRED;
    [_fgView addSubview:_openPad];
    _firstName = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, FGHEIGHT - 115, FGWIDTH/2, 20)];
    _lastName = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, FGHEIGHT - 85, FGWIDTH/2, 20)];
    _username = [[UITextField alloc] initWithFrame:CGRectMake(FGWIDTH/4, FGHEIGHT - 55, FGWIDTH/2, 20)];
    
    
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
    _submit.frame = CGRectMake(FGWIDTH/4, FGHEIGHT - 25, FGWIDTH/2, 20);
    [_submit setTitle:@"Continue" forState:UIControlStateNormal];
    _submit.titleLabel.textColor = GREY;
    [_submit setTitleColor:GREY forState:UIControlStateNormal];
    [_submit addTarget:self action:@selector(submitted:) forControlEvents:UIControlEventTouchUpInside];
    
    [_fgView addSubview:_submit];
    
    _firstName.placeholder = @"First name";
    _lastName.placeholder = @"Last name";
    _username.placeholder = @"Username";
    
    /** Fill the fields if possible */
    NSMutableDictionary* temp = [UserData getUserData];

    if(temp[@"firstname"])
    {
        _firstName.text = temp[@"firstname"];
    }
    
    if (temp[@"lastname"])
    {
        _lastName.text = temp[@"lastname"];
    }
    
    if(temp[@"username"])
    {
        _username.text = temp[@"username"];
    }
    
    /** Allow user to tap out of text fields */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
//    if(temp[@"username"] && temp[@"firstname"] && temp[@"lastname"])
    {
        _fgView.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
        _logo.transform = CGAffineTransformMakeScale(.01, .01);
        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
    }
//    else{
//        ///Don't transform logo since using Explicit animations
//        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//    }

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
    
    _fgView.transform = CGAffineTransformMakeTranslation(0, HEIGHT);
    _logo.transform = CGAffineTransformMakeScale(.01, .01);
    _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
    _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
    _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
    _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
    _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
}

-(void)viewWillAppear:(BOOL)animated
{
    /** Fill the fields if possible */
    NSMutableDictionary* temp = [UserData getUserData];
    
    if(temp[@"firstname"])
    {
        _firstName.text = temp[@"firstname"];
    }
    
    if (temp[@"lastname"])
    {
        _lastName.text = temp[@"lastname"];
    }
    
    if(temp[@"username"])
    {
        _username.text = temp[@"username"];
    }
    
//    if(!UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
//    {
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
//    NSMutableDictionary* temp = [UserData getUserData];

    /** As long as everything exists, animate normally */
//    if(temp[@"username"] && temp[@"firstname"] && temp[@"lastname"])
    {
        /** ANIMATE! */
        
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _fgView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _logo.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:.5 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _openPad.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:.75  usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _firstName.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _lastName.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1.25 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _username.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){}];
        
        [UIView animateWithDuration:.5 delay:1.5 usingSpringWithDamping:.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            _submit.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
        
//        
//            FBLoginView *loginView = [[FBLoginView alloc] init];
//            loginView.center = self.view.center;
//            [self.view addSubview:loginView];

        
        
        }];
    }
//    else /** For the first time the app opens */
//    {
//        [self.navigationController setNavigationBarHidden:YES];
//        {
//            _logo.center = CGPointMake(WIDTH/2, HEIGHT/2);
//            POPSpringAnimation* anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//            anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(.01, .01)];
//            
//            float scaleFactor;
//            scaleFactor = (self.view.bounds.size.width/ _logo.bounds.size.width);
//            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(scaleFactor, scaleFactor)];
//            anim.velocity = [NSValue valueWithCGPoint:CGPointMake(.005, .005)];
//            anim.springBounciness = 20;
//            anim.removedOnCompletion = NO;
//            [_logo.layer pop_addAnimation:anim forKey:@"scale"];
//            
//            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//                NSLog(@"Animation has completed.");
//            };
//        }
//    }
    
//    /** First time app launch only*/ #warning fuck this shit literally
//    else {
//        _openPad.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _firstName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _lastName.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _username.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        _submit.transform = CGAffineTransformMakeTranslation(WIDTH, 0);
//        
//        _logo.frame = CGRectMake(_logo.frame.origin.x, HEIGHT/2 - (_logo.frame.size.height)*2.5/2, _logo.frame.size.width, _logo.frame.size.height);
//        POPSpringAnimation* logoAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//        logoAnim.fromValue = [NSValue valueWithCGPoint:CGPointMake(.01, .01)];
//        logoAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
//        logoAnim.velocity = [NSValue valueWithCGPoint:CGPointMake(.005, .005)];
//        logoAnim.springBounciness = 20;
//        [_logo.layer pop_addAnimation:logoAnim forKey:@"scale"];
//        
//        logoAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
//            NSLog(@"Animation has completed.");
//        };
//        
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
//        
//    }
}


//- (void) animateStarEarnToInt:(int)earnTo {
//    float animDuration = 0.7;
////    
////    /* Find point to start animation */
////    SCNView *scnView = (SCNView *)self.view;
////    LevelModelDynamic *curState = &_dynamicLevelState[_currentStateIndex];
////    SCNVector3 orig   = [_levelNode.nodeT positionForTile:curState->tile_T inModel:_levelModel];
////    orig = [_levelNode worldCoordinateForPosition:orig];
////    SCNVector3 origProj = [scnView projectPoint:orig];
//    
//    CGPoint startCen  = CGPointMake(100,100);//origProj.x, origProj.y);
//    CGPoint endCen   = CGPointMake(400, 400);//_starsImage.center;
//    
//    UIImageView *star_gold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star42"]];
//    
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, startCen.x, startCen.y);
//    CGPathAddQuadCurveToPoint(path, NULL, /*self.view.frame.size.width/2*/ startCen.x, 0, endCen.x, endCen.y);
//    
//    star_gold.center = startCen;
//    star_gold.alpha  = 0;
//    
//    [self.view addSubview:star_gold];
//    
//    /* Animate path */
//    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    pathAnimation.path = path;
//    pathAnimation.duration = animDuration;
//    [star_gold.layer addAnimation:pathAnimation forKey:@"pos"];
//    
//    /* Animate alpha */ {
//        CAKeyframeAnimation *animation;
//        animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
//        animation.duration = animDuration;
//        animation.cumulative = NO;
//        animation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:1], [NSNumber numberWithFloat:0.0], nil];
//        animation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0], [NSNumber numberWithFloat:.03], [NSNumber numberWithFloat:.95], [NSNumber numberWithFloat:1.0], nil];
//        [star_gold.layer addAnimation:animation forKey:@"opa"];
//    }
//    
//    /* Animate size and rotation */
//    {
//        CAKeyframeAnimation *transanimation;
//        transanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        transanimation.duration = animDuration;
//        transanimation.cumulative = NO;
//        transanimation.values = [NSArray arrayWithObjects:           // i.e., Rotation values for the 3 keyframes, in RADIANS
//                                 [NSNumber numberWithFloat:1.0],
//                                 [NSNumber numberWithFloat:2.0],
//                                 [NSNumber numberWithFloat:1.0], nil];
//        transanimation.keyTimes = [NSArray arrayWithObjects:     // Relative timing values for the 3 keyframes
//                                   [NSNumber numberWithFloat:0],
//                                   [NSNumber numberWithFloat:.5],
//                                   [NSNumber numberWithFloat:1.0], nil];
//        transanimation.timingFunctions = [NSArray arrayWithObjects:
//                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],        // from keyframe 1 to keyframe 2
//                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil]; // from keyframe 2 to keyframe 3
//        [star_gold.layer addAnimation:transanimation forKey:@"sca"];
//    }
//    
//    {
//        CAKeyframeAnimation *transanimation;
//        transanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//        transanimation.duration = animDuration;
//        transanimation.cumulative = NO;
//        transanimation.values = [NSArray arrayWithObjects:           // i.e., Rotation values for the 3 keyframes, in RADIANS
//                                 [NSNumber numberWithFloat:M_PI*0.5],
//                                 [NSNumber numberWithFloat:M_PI*1.0],
//                                 [NSNumber numberWithFloat:M_PI*1.5], nil];
//        transanimation.keyTimes = [NSArray arrayWithObjects:     // Relative timing values for the 3 keyframes
//                                   [NSNumber numberWithFloat:0],
//                                   [NSNumber numberWithFloat:.5],
//                                   [NSNumber numberWithFloat:1.0], nil];
//        [star_gold.layer addAnimation:transanimation forKey:@"rot"];
//    }
//    
//    [star_gold performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:animDuration];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        [self menuStarBurst];
////        _starsLabel.text = [NSString stringWithFormat:@"%d", earnTo];
//    });
//    
//    CGPathRelease(path);
//    
//}

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
