//
//  CRViewController.m
//  USFBullRunner
//
//  Created by Lolcat on 31/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRViewController.h"

@interface CRViewController ()

@end

@implementation CRViewController

@synthesize nearbyConnection, nearbyData, routes, locationManager, stops, locationsTableView, uniqueStops, navBar,refreshBarBtn, refreshBtn, arrivalsConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initViews];
    [self startStandardUpdates];
    [self fetchNearbyStops];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initViews
{
    refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0,22,22)];
    UIImage *refreshImg = [UIImage imageNamed:@"Styles/UIButtonBarRefresh@2x_square.png"];
    [refreshBtn setImage:refreshImg forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(fetchNearbyStops) forControlEvents:UIControlEventTouchDown];
    
    
    refreshBarBtn = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [navBar setRightBarButtonItem:refreshBarBtn];
}

- (void)startRotating {
    
    // http://stackoverflow.com/questions/3431776/how-do-you-rotate-a-uiimage-360
    
    NSLog(@"Start rotation");
    
    CALayer *layer = refreshBtn.layer;
    
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 1.5f;
    fullRotation.repeatCount = MAXFLOAT;
    fullRotation.fillMode = kCAFillModeForwards;
    fullRotation.autoreverses = NO;
    
    [layer addAnimation:fullRotation forKey:@"360"];
    
    [layer animationForKey:@"360"];

}

- (void)stopRotating {
    
    NSLog(@"Stop rotation");
    CALayer *layer = refreshBtn.layer;
//    [self pauseLayer:layer];
    
//    NSLog(@"%@ %@ %f %@ %f", NSStringFromCGRect(layer.bounds), NSStringFromCGPoint(layer.position), layer.zPosition, NSStringFromCGPoint(layer.anchorPoint), layer.anchorPointZ);
    
//    NSLog(@"%@", NSStringFromCGAffineTransform(CATransform3DGetAffineTransform(layer.transform)));
    
//    CABasicAnimation *finishRotation;
//    finishRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    finishRotation.fromValue = [layer valueForKeyPath:@"transform"];
//    
//    NSLog(@"%f %f %f %f", layer.transform.m11, layer.transform.m12, layer.transform.m13, layer.transform.m14);
//    NSLog(@"%f %f %f %f", layer.transform.m21, layer.transform.m22, layer.transform.m23, layer.transform.m24);
//    NSLog(@"%f %f %f %f", layer.transform.m31, layer.transform.m32, layer.transform.m33, layer.transform.m34);
//    NSLog(@"%f %f %f %f", layer.transform.m41, layer.transform.m42, layer.transform.m43, layer.transform.m44);
    
//    finishRotation.toValue = [NSNumber numberWithFloat:0];
//    finishRotation.duration = 1.0f;
//    finishRotation.repeatCount = 0;
//    finishRotation.fillMode = kCAFillModeForwards;
//    finishRotation.autoreverses = NO;
//    
//    [layer addAnimation:finishRotation forKey:@"finish"];
    
//    [layer animationForKey:@"finish"];
    
//    [self resumeLayer:layer];
    [layer removeAnimationForKey:@"360"];
    
    
}

-(void)pauseLayer:(CALayer*)layer
{
    // http://stackoverflow.com/questions/2306870/is-there-a-way-to-pause-a-cabasicanimation
    
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)fetchNearbyStops
{
    [self startRotating];
    
    // reset the data
    routes = nil, stops = nil, nearbyData = nil, uniqueStops = nil;
    
    if (routes == nil)
        nearbyData = [[NSMutableData alloc] init];
    if (routes == nil)
        routes = [[NSDictionary alloc] init];
    
    CLLocation *location = locationManager.location;
    
    if (location != nil)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://usfbullrunner.com/api/nearbystops/%f/%f?format=json",
                               location.coordinate.latitude,
                               location.coordinate.longitude];
        NSURL *routesURL = [NSURL URLWithString:urlString];
        NSURLRequest *req = [NSURLRequest requestWithURL:routesURL];
        nearbyConnection = [[NSURLConnection alloc] initWithRequest:req
                                                           delegate:self
                                                   startImmediately:YES];
        NSLog(@"nearbyConnection: %@ %@", nearbyConnection, req);
    }
    
}

- (void) fetchArrivalTimes
{
    int i = 0;
    
    for (NSMutableDictionary * stop in stops)
    {
        i++;
        
        NSString *urlString = [NSString stringWithFormat:@"http://usfbullrunner.com/Route/%@/Stop/%@/Arrivals",
                               [stop objectForKey:@"RouteId"], [stop objectForKey:@"StopId"]];

        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                     timeoutInterval:300];
        
        NSLog(@"%@", urlString);
        
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
        
        NSError *error;
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

       if([data length] > 0 && error == nil) {

           NSMutableArray *arrivals = [decoder mutableObjectWithData:data];
           [stop setValue:arrivals forKey:@"Arrivals"];

       }
       else if ([data length] == 0 && error == nil)
       {
           NSLog(@"Nothing was downloaded.");
       }
       else if (error != nil){
           NSLog(@"Error = %@", error);
       }

    }
//    NSLog(@"stops: %@", stops);

    [locationsTableView reloadData];
    [self stopRotating];
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    if (conn == nearbyConnection)
        [nearbyData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    
    if (conn == nearbyConnection)
    {
        NSLog(@"nearbyConnection Finished loading");
        
        //    NSLog(@"JSON Data: %@", nearbyData);
        
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
        
        if (stops == nil)
            stops = [[NSMutableArray alloc] init];
        if (nearbyData != nil && [nearbyData length] > 0)
        {
            //        NSLog(@"Array of Stops: %@", stops);
            stops = [decoder mutableObjectWithData:nearbyData];
            
            [self fetchArrivalTimes];
        }

    }
}

- (void)connection:(NSURLConnection *)conn DidFailWithError:(NSError *)err
{
    NSLog(@"Did fail with error: %@", err);
}

- (void)startStandardUpdates
{
    
    NSLog(@"Starting standard updates");
    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];

    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    
    [locationManager startUpdatingLocation];
    
}

- (void)startSignificantChangeUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    [locationManager startMonitoringSignificantLocationChanges];
    
    
}

- (void)locationManager:(CLLocationManager *)locationManager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    CLLocation *location = [locations lastObject];
    
    if (oldLocation == nil)
    {
        NSLog(@"LOCATIONS %@ ____ %@", newLocation, oldLocation);
        
        CLLocation *location = newLocation;
        
        NSLog(@"location is: %f %f", location.coordinate.longitude, location.coordinate.latitude);
        
//        [self fetchDataWithLocation:location];
    }

    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager Error: %@", error);
}

- (void)viewDidUnload {
    [self setLocationsTableView:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (stops != nil)
    {
        // init the dictionary
        uniqueStops = nil; // prevent duplicate cells each time the tableisreloaded
        if (uniqueStops == nil) {
            uniqueStops = [[NSMutableDictionary alloc] init];
            [uniqueStops setObject:[[NSMutableArray alloc] init]
                            forKey:@"index"];
        }
        // loop through the stops returned by the api
        [stops enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString *stopName = [stops[idx] objectForKey:@"StopName"];
            NSNumber *numArrivals = [uniqueStops objectForKey:stopName];
            
            // if this stop hasn't been seen before add it to the uniqueStops dict
            if (numArrivals == nil){
                [uniqueStops setObject:[NSNumber numberWithInt:1]
                                forKey:stopName];
                NSMutableArray *index = [uniqueStops objectForKey:@"index"];
                [index addObject:stopName];
                [uniqueStops setObject:index forKey:@"index"];
            }
            // otherwise increment the number of buses arriving at the stop
            else {
                [uniqueStops setObject:[NSNumber numberWithInt:(numArrivals.integerValue + 1)]
                                forKey:stopName];
            }
            
        }];
        return [uniqueStops count] - 1;
    }
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (uniqueStops != nil)
    {
        NSString *index = [uniqueStops objectForKey:@"index"][section];
        NSNumber *rows = [uniqueStops objectForKey:index];
        
//        NSLog(@"numberOfRowsInSection, uniqueStops: %@", uniqueStops);
        return rows.integerValue;
    }
    else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (CGFloat) 40;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect sectionViewRect = [[UIScreen mainScreen] bounds];
    sectionViewRect.size.height = 40;
    CGRect labelRect = CGRectMake(12, 0, sectionViewRect.size.width, 40);
        
    UIView *sectionView = [[UIView alloc] initWithFrame:sectionViewRect];
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, sectionView.frame.size.width, 1.0f);
    topBorder.backgroundColor = [UIColor colorWithRed:0.000 green:0.498 blue:0.345 alpha:1].CGColor;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, sectionViewRect.size.height - 1.0f, sectionViewRect.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.000 green:0.314 blue:0.212 alpha:1].CGColor;
    
    [sectionView.layer addSublayer:topBorder];
    [sectionView.layer addSublayer:bottomBorder];
    
    UIColor *bg = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Styles/black_lozenge.png"]];
    [sectionView setBackgroundColor:bg];
    
    sectionView.nuiClass = @"sectionTitleView";
    label.nuiClass = @"sectionTitleLabel";
    
    if (uniqueStops != nil)
    {
        label.text = [uniqueStops objectForKey:@"index"][section];
    }
    else
    {        
        label.text = @"Searching for nearby stops...";
    }
    
    [sectionView addSubview:label];
    
    return sectionView;
}

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"stopsLength:%lu indexPath.row:%ld indexPath.section: %ld", (unsigned long)[stops count], (long)indexPath.row, (long)indexPath.section);
    
    return [[NSDictionary alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"busLocationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }


    NSDictionary *item = [self itemAtIndexPath:indexPath];
    NSLog(@"item: %@", item);

    UILabel *routeName = (UILabel *)[cell viewWithTag:0];
    
    routeName.nuiClass = @"routeName";

    routeName.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"RouteName"]];
    
    int numLabels = 0;
    
    for (NSDictionary *arrival in [[item objectForKey:@"Arrivals"] objectForKey:@"Predictions"])
    {
        if (arrival != nil)
        {
            [cell addSubview:[self labelForTime:[arrival objectForKey:@"Minutes"]
                                    AndPosition:numLabels]];
            numLabels++;
        }
    }
    
    return  cell;
   
}

- (UILabel *)labelForTime:(NSString *)time AndPosition:(int)pos
{
    CGFloat x = [[UIScreen mainScreen] bounds].size.width - ( 58 * (pos + 1));
    
    UILabel *arrivalTime = [[UILabel alloc]initWithFrame:CGRectMake(x,8,50,30)];
    
    arrivalTime.textColor = [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1];
    arrivalTime.backgroundColor = [UIColor colorWithRed:0.553 green:0.851 blue:0.749 alpha:1];
    arrivalTime.layer.cornerRadius = 8;
    arrivalTime.textAlignment = UITextAlignmentCenter;
    arrivalTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    NSString *arrivalString = [NSString stringWithFormat:@"%@m", time];
    arrivalTime.text = arrivalString;
    
    NSLog(@"ArrivalTimeFrame: %@", NSStringFromCGRect(arrivalTime.frame));
    
    return arrivalTime;
}


@end
