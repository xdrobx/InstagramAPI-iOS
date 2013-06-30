//
//  IAServerManager.h
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/29/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAServerManagerDelegate.h"

@interface IAServerManager : NSObject

@property (nonatomic,weak) id<IAServerManagerDelegate> delegate;

+ (IAServerManager*) getInstanse;
- (void) requestForImages;
@end