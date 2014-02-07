//
//  STUNOperation.h
//  OpenTokHelloWorld
//
//  Created by Jaideep Shah on 1/3/14.
//
//

#import <Foundation/Foundation.h>

@interface OTSTUNOperation : NSOperation

// Designated initializer. The host is a DNS name, the port is typically 3478.
// The default init method is not to be used. Will return an exception, if used.
// This operation is concurrent in nature
//The timeout interval is time in seconds the operation will wait from the moment it is started,to determine
// if a succesfull connection has been made or not. If not the property connected is false
-(id) initWithHost:(NSString*) host port:(NSInteger) port timeout:(NSTimeInterval)time;

//On completion of the operation, this value can be tested to check if the connection was successful or not.
//The timeout interval in the designated initializer ,is time in seconds the operation will wait from the moment it is started,to determine
// if a succesfull connection has been made or not. If not the property connected is false
@property (nonatomic, readonly) BOOL connected;


@end
