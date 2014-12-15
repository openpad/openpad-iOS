//
//  GameListViewController.m
//  GamePadStart
//
//  Created by Jake Saferstein on 10/25/14.
//  Copyright (c) 2014 Jake Saferstein. All rights reserved.
//

#import "GameListViewController.h"
#import "SocketManager.h"
#import "ControllerViewController.h"
#import "TestLoginViewController.h"
#import "BackgroundLayer.h"


@interface GameListViewController ()

@end

@implementation GameListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.height, self.view.bounds.size.width) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
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
    
//    if(!UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
//    {
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Games";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed:)];
    self.navigationItem.leftBarButtonItem.tintColor = DARKGREY;
    
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = GREY;
    self.refreshControl.tintColor = DARKGREY;
    [self.refreshControl addTarget:self
                            action:@selector(discoverServers)
                  forControlEvents:UIControlEventValueChanged];
    
    
    [self discoverServers];
}

-(void)discoverServers
{
    [[SocketManager manager] disconnectAll];
    [[SocketManager manager] discoverServers];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self discoverServers];
    [self.tableView reloadData];
//    if(!UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
//    {
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons
-(void)settingsPressed:(UIButton *) button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([[SocketManager manager].connections count] == 0)
    {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No games found. \n Please pull down to refresh.";
        messageLabel.textColor = GREY;
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundColor = BLACK;
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        return 0;
    }
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = BLACK;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[SocketManager manager].connections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"game"];
    if (!cell)
    {
        cell = [[GameTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"game"];
    }
    
    [cell setConn:[SocketManager manager].connections[indexPath.row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Request* r = [[Request alloc] initWithOp:2];
    GameTableCell* temp = (GameTableCell *) [tableView cellForRowAtIndexPath:indexPath];
    [temp.conn.socket writeData:[r serializeToJSON] withTimeout:-1 tag:2];
    
    ControllerViewController* toShow = [ControllerViewController sharedInstance];
    toShow.game = ((GameTableCell *)[tableView cellForRowAtIndexPath:indexPath]).conn;
    [self presentViewController:toShow animated:NO completion:^{
        NSLog(@"Presenting ControllerViewController");
    }];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
