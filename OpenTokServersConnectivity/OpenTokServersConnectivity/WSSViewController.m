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
                            @"mantis702-mia.tokbox.com" :@443,
                            @"mantis403-oak.tokbox.com" :@443,
                            @"mantis901-mia.tokbox.com" :@443,
                            @"mantis502-nyc.tokbox.com" :@443,
                            @"mantis501-nyc.tokbox.com" :@443,
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


-(void) connectivityChecks
{
    //make all the op asyn using operation q
    NSOperationQueue * q = [NSOperationQueue new];
    int numberofServers = self.hosts.count;
    __block int serverTested = 0;
    
    [self.hosts enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        OTWebSocketOperation * operation = [[OTWebSocketOperation alloc] initWithHost:key port:[obj integerValue] timeout:10];
        __block __weak OTWebSocketOperation * weakOperation = operation;
        operation.completionBlock = ^{
            

            
            NSAssert( weakOperation != nil, @"pointer is nil" );
            if(weakOperation.connected == YES)
            {
                [self host:key connected:YES];
                NSLog(@"Connected to %@ at port %d (%d/%d), wss test",key,[obj integerValue],++serverTested,numberofServers);
                
            } else {
                [self host:key connected:NO];
                NSLog(@"Not connected to %@ at port %d (%d/%d), wss test FAILED",key,[obj integerValue],++serverTested,numberofServers);
            }
            weakOperation = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressBar.progress =  ((float)serverTested/(float)self.hosts.count);
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
                self.checkingForConnectivityDone = (serverTested == self.hosts.count);
                
            });
            
        };
        [q addOperation:operation];
    }];
    
}

-(OTConnectivityBaseOperation * ) operationToPerformWithHost:(NSString *) host port:(int)portNum timeout:(NSTimeInterval)time
{
    return [[OTWebSocketOperation alloc] initWithHost:host port:portNum timeout:time];
}

@end
