//
//  IAServerManagerDelegate.h
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/30/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IAServerManagerDelegate <NSObject>
@required
- (void)showProgress;
- (void)dismissProgress;
@optional
- (void)didReceiveImageUrls:(NSArray*)urls;
@end
