//
//  WSSViewController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "WSSViewController.h"
#import "OTWebSocketOperation.h"

@interface WSSViewController ()

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
