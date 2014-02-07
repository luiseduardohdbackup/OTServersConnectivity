//
//  TCPViewController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/6/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "TCPViewController.h"
#import "OTTCPOperation.h"
#import "OTHost.h"

@interface TCPViewController ()
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSDictionary * tcpHosts;
@end

@implementation TCPViewController

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
    self.entries = [NSMutableArray new];
    
    //mantis servers use TCP during start up after that UDP. The UDP part is tested indirectly via STUN - see below
    self.tcpHosts =   @{@"anvil.opentok.com": @80,
                        @"hlg.tokbox.com" : @80,
                        @"oscar.tokbox.com" : @80,
                        @"dev.oscar.tokbox.com" : @80,
                        @"mantis504-nyc.tokbox.com" :@5560,
                        @"mantis503-nyc.tokbox.com" :@5560,
                        @"mantis404-oak.tokbox.com" :@5560,
                        @"mantis802-lhr.tokbox.com" :@5560,
                        @"mantis702-mia.tokbox.com" :@5560,
                        @"mantis403-oak.tokbox.com" :@5560,
                        @"mantis901-mia.tokbox.com" :@5560,
                        @"mantis502-nyc.tokbox.com" :@5560,
                        @"mantis501-nyc.tokbox.com" :@5560,
                        @"mantis401-oak.tokbox.com" :@5560,
                        @"mantis402-oak.tokbox.com" :@5560,
                        @"mantis801-lhr.tokbox.com" :@5560,
                        @"turn702-mia.tokbox.com" :@443,
                        @"turn801-lhr.tokbox.com" :@443,
                        @"mantis901-mia.tokbox.com" :@443,
                        @"turn401-oak.tokbox.com" :@443,
                        @"turn403-oak.tokbox.com" :@443,
                        @"turn503-nyc.tokbox.com" :@443,
                        @"turn802-lhr.tokbox.com" :@443,
                        @"turn402-oak.tokbox.com" :@443,
                        @"turn502-nyc.tokbox.com" :@443,
                        @"turn404-oak.tokbox.com" :@443,
                        @"turn504-nyc.tokbox.com" :@443,
                        @"turn501-nyc.tokbox.com" :@443,
                        };
    
    [self.tcpHosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OTHost * host = [OTHost new];
        host.name = key;
        host.port = [obj integerValue];
        host.connected = NO;
        
        [self.entries addObject:host];
        
     }];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeAllHosts];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self tcpConnectivityChecks];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    OTHost * host = [self.entries objectAtIndex:indexPath.row];
    cell.textLabel.text = host.name;
	cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", (int)host.port];
    if(host.connected)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
#pragma  mark TCP Connectivity
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
-(void) tcpConnectivityChecks
{
    
    
    //make all the op asyn using operation q
    NSOperationQueue * q = [NSOperationQueue new];
    int numberofServers = self.tcpHosts.count;
    __block int serverTested = 0;
    
    [self.tcpHosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OTTCPOperation * operation = [[OTTCPOperation alloc] initWithHost:key port:[obj integerValue]];
        __block __weak OTTCPOperation * weakOperation = operation;
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
            [self.tableView reloadData];
            [self.tableView setNeedsDisplay];
            
        };
        [q addOperation:operation];
    }];
    
}


@end
