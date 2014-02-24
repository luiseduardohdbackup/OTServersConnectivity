//
//  ConnectivityTableViewBaseController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "ConnectivityTableViewBaseController.h"
#import "TableViewCell.h"
#import "OTConnectivityBaseOperation.h"
#import "OTTCPOperation.h"
#import "OTSTUNOperation.h"
#import "OTWebSocketOperation.h"

@implementation OTHost
@end


@interface ConnectivityTableViewBaseController ()
@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSOperationQueue * queue;



@end

@implementation ConnectivityTableViewBaseController

//Helper for creating protocol based individual controllers
+(ConnectivityTableViewBaseController *) connectivityTableViewBaseControllerWithType : (ConnectivityTableViewBaseControllerType) type
{
//    switch (type) {
//        case ConnectivityTableViewBaseController_TCP:
//            return [
//            break;
//            
//        default:
//            break;
//    }
    return nil;
}
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
        host.refreshing = NO;
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
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(connectivityChecks) forControlEvents:UIControlEventValueChanged];
   
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.queue = [NSOperationQueue new];
    [self.queue setMaxConcurrentOperationCount:3];
    
    [self initializeAllHosts];
    [self initializeDisplayTitle];
    
    self.progressBar.progress = 0.0;
    
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
    //NSLog(@"Row = %d connected=%d" ,indexPath.row, host.connected);
    //If checking is not being done don't show any image
    if(host.refreshing == YES)
    {
        cell.connectedStatusView.image = nil;
        [cell.activityView startAnimating];
        
    } else {
        [cell.activityView stopAnimating];
        if(host.connected)
        {
            cell.connectedStatusView.image = [UIImage imageNamed:@"connected.png"];
        } else {
            cell.connectedStatusView.image = [UIImage imageNamed:@"notConnected.png"];
        }

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
            host.refreshing = NO;
            *stop = YES;
        }
    } ];
    
}


-(void) resetModel
{
    [self.queue cancelAllOperations];
    
    //refresh all hosts to start filling in the model
    [self.entries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OTHost * host = obj;
        host.refreshing = YES;
    } ];
    

    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"server tested %d %@",serverTested,key);
        self.progressBar.progress =  0;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        [self.tableView setNeedsDisplay];

        
    });

   

}

-(void) connectivityChecks
{
    
    [self resetModel];
 
    __block int serverTested = 0;
    
    [self.hosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        
        OTConnectivityBaseOperation * operation = [self operationToPerformWithHost:key port:[obj integerValue] timeout:10];
        NSAssert(operation != nil,@"pointer is nil" );
        
        __block __weak OTConnectivityBaseOperation * weakOperation = operation;
        operation.completionBlock = ^{
            if(weakOperation.isCancelled == NO)
            {
                NSAssert( weakOperation != nil, @"pointer is nil" );
                
                [self host:key connected:weakOperation.connected];
                
                weakOperation = nil;
                serverTested++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //NSLog(@"server tested %d %@",serverTested,key);
                    self.progressBar.progress =  ((float)serverTested/(float)self.hosts.count);
                    [self.tableView reloadData];
                    [self.tableView setNeedsDisplay];
                    
                });

            } else {
                NSLog(@"OPERATION +CANCELLED");
            }
            
        };
        
        
        [self.queue addOperation:operation];
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

@implementation TCPViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.hosts =   @{@"anvil.opentok.com": @80,
                         
                         @"hlg.tokbox.com" : @80,
                         
                         @"oscar.tokbox.com" : @80,
                         @"dev.oscar.tokbox.com" : @80,
                         
                         @"mantis504-nyc.tokbox.com" :@5560,
                         @"mantis503-nyc.tokbox.com" :@5560,
                         @"mantis404-oak.tokbox.com" :@5560,
                         @"mantis802-lhr.tokbox.com" :@5560,
                         @"mantis403-oak.tokbox.com" :@5560,
                         @"mantis901-mia.tokbox.com" :@5560,
                         @"mantis502-nyc.tokbox.com" :@5560,
                         @"mantis501-nyc.tokbox.com" :@5560,
                         @"mantis902-mia.tokbox.com" :@5560,
                         @"mantis401-oak.tokbox.com" :@5560,
                         @"mantis402-oak.tokbox.com" :@5560,
                         @"mantis801-lhr.tokbox.com" :@5560,
                         
                         @"turn702-mia.tokbox.com" :@443,
                         @"turn902-mia.tokbox.com" :@443,
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
        
    }
    return self;
}
-(void) initializeDisplayTitle
{
    self.title = @"Tokbox TCP checks";
}


-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time
{
    return [[OTTCPOperation alloc] initWithHost:host port:portNum timeout:time];
}


@end

@implementation STUNViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.hosts =   @{   @"turn702-mia.tokbox.com": @3478,
                            @"mantis902-mia.tokbox.com": @3478,
                            @"turn801-lhr.tokbox.com": @3478,
                            @"mantis901-mia.tokbox.com": @3478,
                            @"turn401-oak.tokbox.com": @3478,
                            @"turn403-oak.tokbox.com": @3478,
                            @"turn503-nyc.tokbox.com": @3478,
                            @"turn802-lhr.tokbox.com": @3478,
                            @"turn402-oak.tokbox.com": @3478,
                            @"turn502-nyc.tokbox.com": @3478,
                            @"turn404-oak.tokbox.com": @3478,
                            @"turn504-nyc.tokbox.com": @3478,
                            @"turn501-nyc.tokbox.com": @3478,
                            };
        
    }
    return self;
}
-(void) initializeDisplayTitle
{
    self.title = @"Tokbox Stun/Udp checks";
}

-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time
{
    return [[OTSTUNOperation alloc] initWithHost:host port:portNum timeout:time];
}


@end

@implementation WSSViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.hosts =      @{@"mantis504-nyc.tokbox.com" :@443,
                            @"mantis503-nyc.tokbox.com" :@443,
                            @"mantis404-oak.tokbox.com" :@443,
                            @"mantis802-lhr.tokbox.com" :@443,
                            
                            @"mantis403-oak.tokbox.com" :@443,
                            @"mantis901-mia.tokbox.com" :@443,
                            @"mantis502-nyc.tokbox.com" :@443,
                            @"mantis501-nyc.tokbox.com" :@443,
                            @"mantis902-mia.tokbox.com" :@443,
                            @"mantis401-oak.tokbox.com" :@443,
                            @"mantis402-oak.tokbox.com" :@443,
                            @"mantis801-lhr.tokbox.com" :@443,
                            };
        
        
        
    }
    return self;
}
-(void) initializeDisplayTitle
{
    self.title = @"Tokbox Websockets checks";
}


-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time
{
    return [[OTWebSocketOperation alloc] initWithHost:host port:portNum timeout:time];
}

@end



