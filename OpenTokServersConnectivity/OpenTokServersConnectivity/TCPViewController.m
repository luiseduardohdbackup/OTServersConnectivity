//
//  TCPViewController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/6/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "TCPViewController.h"
#import "OTTCPOperation.h"


@interface TCPViewController ()

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
