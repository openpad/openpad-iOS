//
//  ControllerViewController.m
//  GamePadStart
//
//  Created by Jake Saferstein on 11/10/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "ControllerViewController.h"
#import "StaticControl.h"

@interface ControllerViewController ()

@end

@implementation ControllerViewController

SINGLETON_IMPL(ControllerViewController);

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BLACK;
    
    _backButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(10, 10, 50, 20);
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    _backButton.titleLabel.textColor = GREY;
    [_backButton setTitleColor:GREY forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(disconnected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    [self loadControls];
}

-(void)disconnected:(UIButton *) button
{
   [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
       NSLog(@"Going back?!?");
   }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    Request* r = [[Request alloc] initWithOp:3];
    [_game sendRequest:r];
    self.game = nil;
    for (UIView* temp in [self.view subviews]) {
        [temp removeFromSuperview];
    }
    self.controls = [NSMutableDictionary dictionary];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    _backButton= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backButton.frame = CGRectMake(10, 10, 50, 20);
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    _backButton.titleLabel.textColor = GREY;
    [_backButton setTitleColor:GREY forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(disconnected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

-(void)loadControls{
    NSArray* controlsArray = _game.padconfig[@"controls"];
    for(NSDictionary* ctrl in controlsArray){
        int type = [ctrl[@"type"] intValue];
        switch(type){
            case 0: /** Button Control */
            {
                ButtonControl* temp = [[ButtonControl alloc] init];
                [temp load:ctrl withParentView:self.view];
                [self.view addSubview:temp];
                [_controls setValue:temp forKey:[[NSNumber numberWithInt:temp.idNum] stringValue]];
            }
                break;
            case 1: /** D-pad Control */
            {
                DPadControl* temp = [[DPadControl alloc] init];
                [temp load:ctrl withParentView:self.view];
                [self.view addSubview:temp];
                [_controls setValue:temp forKey:[[NSNumber numberWithInt:temp.idNum] stringValue]];
            }
                break;
            case 2: /** Analog Joystick */
            {
                JoyStickControl* temp = [[JoyStickControl alloc] init];
                [temp load:ctrl withParentView:self.view];
                [self.view addSubview:temp];
                [_controls setValue:temp forKey:[[NSNumber numberWithInt:temp.idNum] stringValue]];
            }
                break;
            case 3: /** Static Image */
            {
                StaticControl* temp = [[StaticControl alloc] init];
                [temp load:ctrl withParentView:self.view];
                [self.view addSubview:temp];
                [_controls setValue:temp forKey:[[NSNumber numberWithInt:temp.idNum] stringValue]];
            }
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
