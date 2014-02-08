//
//  STUNViewController.m
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/6/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "STUNViewController.h"
#import "OTSTUNOperation.h"

@interface STUNViewController ()

@end

@implementation STUNViewController
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.hosts =   @{@"turn702-mia.tokbox.com": @3478,
                            @"turn801-lhr.tokbox.com": @3478,
                            @"mantis901-mia.tokbox.com": @3478,
                            @"turn401-oak.tokbox.com": @3478,
                            @"turn403-oak.tokbox.com": @3478,
                            @"turn503-nyc.t okbox.com": @3478,
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
