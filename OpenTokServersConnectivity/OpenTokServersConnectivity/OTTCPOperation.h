//
//  TCPOperation.h
//  OpenTokHelloWorld
//
//  Created by Jaideep Shah on 1/2/14.
//
//

#import <Foundation/Foundation.h>
#import "OTConnectivityBaseOperation.h"

@interface OTTCPOperation : OTConnectivityBaseOperation

// Designated initializer. The host is a DNS name.
// The default init method is not to be used. Will return an exception, if used.
// This operation is concurrent in nature
-(id) initWithHost:(NSString*) host port:(NSInteger) port timeout:(NSTimeInterval)time;


@end
