//
//  ConnectivityTableViewBaseController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "ConnectivityTableViewBaseController.h"
#import "TableViewCell.h"
#import "OTHost.h"
#import "OTConnectivityBaseOperation.h"


@interface ConnectivityTableViewBaseController ()
@property (nonatomic, strong) NSMutableArray *entries;




@end

@implementation ConnectivityTableViewBaseController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initializeAllHosts
{
    [self.hosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OTHost * host = [OTHost new];
        host.name = key;
        host.port = [obj integerValue];
        host.connected = NO;
        
        [self.entries addObject:host];
        
    }];

}
//override
-(void) initializeDisplayTitle
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.entries = [NSMutableArray new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initializeAllHosts];
    [self initializeDisplayTitle];
 
}
-(void) viewDidAppear:(BOOL)animated
{
    self.progressBar.progress = 0.0;
    self.checkingForConnectivityDone = NO;
    [self connectivityChecks];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
      return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    OTHost * host = [self.entries objectAtIndex:indexPath.row];
    cell.host.text = host.name;
	cell.port.text = [NSString stringWithFormat: @"%d", (int)host.port];
    
    //If checking is not being done don't show any image
    if(self.checkingForConnectivityDone == YES)
    {
        if(host.connected)
        {
            cell.connectedStatusView.image = [UIImage imageNamed:@"connected.png"];
        } else {
            cell.connectedStatusView.image = [UIImage imageNamed:@"notConnected.png"];
        }
    } else {
        cell.connectedStatusView.image = nil;
    }
    return cell;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void) host:(NSString *)hostName connected:(BOOL)f
{
    [self.entries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OTHost * host = obj;
        if([hostName isEqualToString:host.name] == YES)
        {
            host.connected = f;
            *stop = YES;
        }
    } ];
    
}
-(void) connectivityChecksRR
{
    
}
-(void) connectivityChecks
{
    //make all the op asyn using operation q
    NSOperationQueue * q = [NSOperationQueue new];
    int numberofServers = self.hosts.count;
    __block int serverTested = 0;
    
    [self.hosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OTConnectivityBaseOperation * operation = [self operationToPerformWithHost:key port:[obj integerValue] timeout:10];
        NSAssert(operation,nil);
       
        __block __weak OTConnectivityBaseOperation * weakOperation = operation;
        operation.completionBlock = ^{
            
            
            
            NSAssert( weakOperation != nil, @"pointer is nil" );
            if(weakOperation.connected == YES)
            {
                [self host:key connected:YES];
                NSLog(@"Connected to %@ at port %d (%d/%d), tcp test",key,[obj integerValue],++serverTested,numberofServers);
                
            } else {
                [self host:key connected:NO];
                NSLog(@"Not connected to %@ at port %d (%d/%d), tcp test FAILED",key,[obj integerValue],++serverTested,numberofServers);
                
            }
            weakOperation = nil;
            
            self.progressBar.progress =  ((float)serverTested/(float)self.hosts.count);
            
            if(serverTested == self.hosts.count)
            {
                self.checkingForConnectivityDone = YES;
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
                
            } else {
                
            }
            
        };
        
        [q addOperation:operation];
    }];
    
}

-(void) postOperationUI
{
    
}

-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time
{
    return nil;
}
@end
