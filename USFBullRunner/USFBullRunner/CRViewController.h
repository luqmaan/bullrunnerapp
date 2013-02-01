//
//  CRViewController.h
//  USFBullRunner
//
//  Created by Lolcat on 31/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit/JSONKit.h>

@interface CRViewController : UIViewController

@property NSURLConnection *connection;
@property NSMutableData *jsonData;
@property NSDictionary *routes;

- (void) fetchData;

@end
