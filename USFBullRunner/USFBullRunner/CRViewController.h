//
//  CRViewController.h
//  USFBullRunner
//
//  Created by Lolcat on 31/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit/JSONKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CRViewController : UITableViewController <CLLocationManagerDelegate>

@property NSURLConnection *nearbyConnection;
@property NSMutableData *jsonData;
@property NSDictionary *routes;
@property CLLocationManager *locationManager;
@property NSArray *stops;

@property (strong, nonatomic) IBOutlet UITableView *locationsTableView;

- (void)fetchNearbyStops;
- (void)fetchArrivalsForStop:(NSString *)stopId;
@end
