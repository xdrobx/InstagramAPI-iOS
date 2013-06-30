//
//  IAViewController.h
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/29/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAServerManager.h"
#import "IAImageCell.h"

@interface IAViewController : UITableViewController <IAServerManagerDelegate>
{
    dispatch_queue_t _imageQueue;
}
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) IAServerManager *manager;
@property (nonatomic, strong) NSArray* imageUrls;
@end
