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
#import <NUI/UIView+NUI.h>
#import <NUI/UILabel+NUI.h>
#import <QuartzCore/QuartzCore.h> 
#import "CRArrivalsForStop.h"
#import <CHDataStructures/CHOrderedDictionary.h>

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface CRViewController : UITableViewController <CLLocationManagerDelegate>

@property NSURLConnection *nearbyConnection;
@property NSURLConnection *arrivalsConnection;
@property NSMutableData *nearbyData;
@property NSDictionary *routes;
@property CLLocationManager *locationManager;
@property NSMutableArray *stops;
@property CHOrderedDictionary *uniqueStops;
/* used for the sections in the tableview.
    uniqueStops: {
        "Maple":3, // (number of rows in section, aka buses arriving to this stop)
        "Holly":3,
        "MSC":5
     }
 */
@property UIBarButtonItem *refreshBarBtn;
@property UIButton *refreshBtn;
@property UILabel *arrivalTimeLabel;

@property (strong, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

- (void)fetchNearbyStops;
//- (void)fetchArrivalsForStop:(NSString *)stopId;
@end
