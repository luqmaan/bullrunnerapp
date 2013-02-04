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

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface CRViewController : UITableViewController <CLLocationManagerDelegate>

@property NSURLConnection *nearbyConnection;
@property NSURLConnection *arrivalsConnection;
@property NSMutableData *nearbyData;
@property NSDictionary *routes;
@property CLLocationManager *locationManager;
@property NSMutableArray *stops;
@property NSMutableDictionary *uniqueStops;
        /* used for the sections in the tableview.
            uniqueStops: {
                "index":["Maple","Holly","MSC"], // position in the uniqueStops dictionary, used for searchign with numberOfRowsInSection:(NSInteger)section
                "Maple":3, // (number of rows in section, aka buses arriving to this stop)
                "Holly":3,
                "MSC":5
             }
         */
@property UIBarButtonItem *refreshBarBtn;
@property UIButton *refreshBtn;


@property (strong, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

- (void)fetchNearbyStops;
//- (void)fetchArrivalsForStop:(NSString *)stopId;
@end
