//
//  CRArrivalsForStop.h
//  USFBullRunner
//
//  Created by Lolcat on 03/02/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONKit/JSONKit.h>

@interface CRArrivalsForStop : NSObject

@property NSURLConnection *connection;

- (NSDictionary *) fetchArrivalsForStop:(NSString *)id WhenDone:(void(^)(void))doneFindingImages;

@end
