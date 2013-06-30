//
//  IAServerManager.m
//  InstagramAPI-iOS
//
//  Created by Sergei Pekar on 6/29/13.
//  Copyright (c) 2013 Sergei Pekar. All rights reserved.
//

#import "IAServerManager.h"

//possible solutions
//https://github.com/nicklockwood/AsyncImageView
//https://github.com/rs/SDWebImage

static IAServerManager* instance = nil;

@implementation IAServerManager
+ (IAServerManager*) getInstanse
{
    @synchronized ( self ){
		if (instance == nil){
			instance = [IAServerManager new];
		}
	}
	
	return instance;
}

- (void) requestForImages
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL_POPULAR]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error: &jsonParsingError];
    
    NSMutableArray* urls = [NSMutableArray new];
    
    if (jsonParsingError == nil) {
        NSArray *items = [jsonResponse objectForKey:@"data"];
        
        //get pictures urls
        for (NSDictionary *item in items) {
            [urls addObject: [[[item objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
            
            //get commentators profile photos urls
            NSArray* commentsPhotos = [[item objectForKey:@"comments"] objectForKey:@"data"];
            for (NSDictionary* commentPhoto in commentsPhotos) { 
                 [urls addObject: [[commentPhoto objectForKey:@"from"] objectForKey:@"profile_picture"]];
            }
        }
    }
    
    if (self.delegate != nil) {
        [self.delegate performSelector:@selector(didReceiveImageUrls:) withObject:urls];
    }
}
@end