//
//  ConnectivityTableViewBaseController.h
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTConnectivityBaseOperation;

typedef NS_ENUM(NSUInteger, ConnectivityTableViewBaseControllerType) {
    ConnectivityTableViewBaseController_TCP,
    ConnectivityTableViewBaseController_STUN_UDP,
    ConnectivityTableViewBaseController_WSS,
    
};

@interface OTHost : NSObject
@property (nonatomic, strong) NSString * name;
@property int port;
@property BOOL connected;
@property BOOL refreshing;
@end

@interface ConnectivityTableViewBaseController : UITableViewController

//Helper for creating protocol based individual controllers
+(ConnectivityTableViewBaseController *) connectivityTableViewBaseControllerWithType : (ConnectivityTableViewBaseControllerType) type;

// set this to your host list else nothing gets checked
@property (nonatomic, strong) NSDictionary * hosts;



//link your progress bar here
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

//use to set host with connected or not flag
-(void) host:(NSString *)hostName connected:(BOOL)f;

//use to inject your own OTConnectivityBaseOperation
-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time;

//use when your NSOperation completion block is called at the end to do UI stuff
-(void) postOperationUI;
@end



@interface TCPViewController : ConnectivityTableViewBaseController
@end

@interface STUNViewController : ConnectivityTableViewBaseController
@end

@interface WSSViewController : ConnectivityTableViewBaseController
@end

