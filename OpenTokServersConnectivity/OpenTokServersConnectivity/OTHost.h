//
//  OTHost.h
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/6/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTHost : NSObject
@property (nonatomic, strong) NSString * name;
@property int port;
@property BOOL connected;
@property BOOL refreshing;
@end
