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

@synthesize nearbyConnection, nearbyData, routes, locationManager, stops, locationsTableView, uniqueStops;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self startStandardUpdates];
    [self fetchNearbyStops];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchNearbyStops
{
    if (nearbyData == nil)
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
            stops = [[NSArray alloc] init];
        if (nearbyData != nil && [nearbyData length] > 0)
        {
            //        NSLog(@"Array of Stops: %@", stops);
            stops = [decoder objectWithData:nearbyData];
            [locationsTableView reloadData];
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
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (stops != nil)
    {
        // init the dictionary
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
        NSString *stopName = [uniqueStops objectForKey:@"index"][section];
        NSNumber *rows = [uniqueStops objectForKey:stopName];
        return rows.integerValue;
    }
    else return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (uniqueStops != nil)
    {
        NSLog(@"Getting title, section: %d", section);
        return [uniqueStops objectForKey:@"index"][section];
    }
    else
        return @"Searching for nearby stops...";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
//    if (stops != nil)
//    {
    
    
        static NSString *CellIdentifier = @"busLocationCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
//        NSLog(@"indexPath: %d", indexPath.row);
    
        NSDictionary *item = [stops objectAtIndex:indexPath.row];
//        NSString *stopName = [item objectForKey:@"StopName"];
//        NSLog(@"Stop Name: %@", stopName);
    
        UILabel *routeName = (UILabel *)[cell viewWithTag:0];
        UILabel *arrivalTime = (UILabel *)[cell viewWithTag:1];
        
        routeName.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"RouteName"]];
        arrivalTime.text = [NSString stringWithFormat:@"%@", [item objectForKey:@"Distance"]];
    
       
        return  cell;
//    }
    
}


@end
