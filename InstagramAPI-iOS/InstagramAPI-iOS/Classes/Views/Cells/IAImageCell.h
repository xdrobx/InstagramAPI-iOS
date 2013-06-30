//
//  IAImageCell.h
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/30/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAImageCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView* progress;
@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) IBOutlet UILabel* imageIndexTxt;
@end
