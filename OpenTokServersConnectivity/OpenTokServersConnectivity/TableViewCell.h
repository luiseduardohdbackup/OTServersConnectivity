//
//  TableViewCell.h
//  OpenTokServersConnectivity
//
//  Created by Jaideep Shah on 2/7/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *host;
@property (nonatomic, strong) IBOutlet UILabel *port;
@property (nonatomic, strong) IBOutlet UIImageView *connectedStatusView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityView;
@end
