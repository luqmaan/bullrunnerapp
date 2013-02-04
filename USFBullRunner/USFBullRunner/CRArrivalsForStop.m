//
//  CRArrivalsForStop.m
//  USFBullRunner
//
//  Created by Lolcat on 03/02/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import "CRArrivalsForStop.h"

@implementation CRArrivalsForStop

@synthesize connection;

- (id)init {
    
    int routeNumbers[] = {883,427,425,428,423,426};
    
    NSMutableDictionary *stopInformation = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < sizeof(routeNumbers)/sizeof(int); i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"Data/%d", routeNumbers[i]];
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                         ofType:@"json"];
        NSData *routeData = [NSData dataWithContentsOfFile:path];
                
        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
        NSArray *stopsOnRoute = [decoder objectWithData:routeData];

        [stopInformation setObject:stopsOnRoute forKey:[NSString stringWithFormat:@"%d", routeNumbers[i]]];
    } 
    
    return self;
}
- (NSDictionary *) fetchArrivalsForStop:(NSString *)id WhenDone:(void(^)(void))doneFindingImages;
{
    
    
    return [[NSDictionary alloc]  init];
}
//    NSString *urlString = [NSString stringWithFormat:@"http://usfbullrunner.com//Route/%@/Stop/%@/Arrivals", routeId, stopId];
//    
//    NSURL *routesURL = [NSURL URLWithString:urlString];
//    NSURLRequest *req = [NSURLRequest requestWithURL:routesURL];
//    connection = [[NSURLConnection alloc] initWithRequest:req
//                                                 delegate:self
//                                         startImmediately:YES];
//    
//}
//
//- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
//{
//    if (conn == connection)
//        [nearbyData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)conn
//{
//    
//    if (conn == connection)
//    {
//        NSLog(@"connection Finished loading");
//        
//        //    NSLog(@"JSON Data: %@", nearbyData);
//        
//        JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionStrict];
//        
//        if (stops == nil)
//            stops = [[NSArray alloc] init];
//        if (nearbyData != nil && [nearbyData length] > 0)
//        {
//            //        NSLog(@"Array of Stops: %@", stops);
//            stops = [decoder objectWithData:nearbyData];
//            [locationsTableView reloadData];
//            [self stopRotating];
//        }
//        
//    }
//}
//
//}
//
//- (void)connection:(NSURLConnection *)conn DidFailWithError:(NSError *)err
//{
//    NSLog(@"Did fail with error: %@", err);
//}
//
@end
