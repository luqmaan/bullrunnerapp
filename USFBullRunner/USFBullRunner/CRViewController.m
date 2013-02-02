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

@synthesize nearbyConnection, jsonData, routes, locationManager, stops, locationsTableView;

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
    if (jsonData == nil)
        jsonData = [[NSMutableData alloc] init];
    if (routes == nil)
        routes = [[NSDictionary alloc] init];
    
//    NSLog(@"Location: %@", location);
    CLLocation *location = locationManager.location;
    
    if (location != nil)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://usfbullrunner.com/api/nearbystops/%f/%f?format=json", location.coordinate.latitude, location.coordinate.longitude];
        
        NSLog(@"URL String: %@", urlString);
        NSURL *routesURL = [NSURL URLWithString:urlString];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:routesURL];
        
        nearbyConnection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    }
    
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
//    NSLog(@"Did receive data: %@", data);
    [jsonData appendData:data];
//    NSLog(@"JSONData is now: %@", jsonData);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    
    if (conn == nearbyConnection)
    {
        NSLog(@"Did finish loading");
        
        //    NSLog(@"JSON Data: %@", jsonData);
        
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
        
        if (stops == nil)
            stops = [[NSArray alloc] init];
        if (jsonData != nil && [jsonData length] > 0)
        {
            //        NSLog(@"Array of Stops: %@", stops);
            stops = [decoder objectWithData:jsonData];
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
        __block NSMutableSet *uniqueStops = [[NSMutableSet alloc] init];
        [stops enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [uniqueStops addObject:[stops[idx] objectForKey:@"StopName"]];
        }];
        return [uniqueStops count];
    }
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stops.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Nearby Locations";
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
