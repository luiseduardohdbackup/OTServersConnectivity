//
//  OTWebSocketOperation.h
//  OpenTokHelloWorld
//
//  Created by Jaideep Shah on 2/3/14.
//
//

#import <Foundation/Foundation.h>

@interface OTWebSocketOperation : NSOperation
// Designated initializer. The host is a DNS name.
// The default init method is not to be used. Will return an exception, if used.
// This operation is concurrent in nature
-(id) initWithHost:(NSString*) host port:(NSInteger) port timeout:(NSTimeInterval)time;

//On completion of the operation, this value can be tested to check if the connection was successful or not
@property (nonatomic, readonly) BOOL connected;


@end
