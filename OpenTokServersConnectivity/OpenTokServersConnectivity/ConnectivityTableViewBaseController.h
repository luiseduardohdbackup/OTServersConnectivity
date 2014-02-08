//
//  ConnectivityTableViewBaseController.h
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTConnectivityBaseOperation;

@interface ConnectivityTableViewBaseController : UITableViewController
// set this to your host list else nothing gets checked
@property (nonatomic, strong) NSDictionary * hosts;

//use this flag to control table reloads
@property BOOL checkingForConnectivityDone;

//link your progress bar here
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

//use to set host with connected or not flag
-(void) host:(NSString *)hostName connected:(BOOL)f;

//use to inject your own OTConnectivityBaseOperation
-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time;

//use when your NSOperation completion block is called at the end to do UI stuff
-(void) postOperationUI;
@end
