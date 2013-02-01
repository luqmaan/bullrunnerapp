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

@synthesize connection, jsonData, routes;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self fetchData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchData
{
    jsonData = [[NSMutableData alloc] init];
    routes = [[NSDictionary alloc] init];
    
    NSURL *routesURL = [NSURL URLWithString:@"http://usfbullrunner.com/api/nearbystops/28.0656563836558/-82.4112689495087"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:routesURL];
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    NSLog(@"Did receive data: %@", data);
    [jsonData appendData:data];
    NSLog(@"JSONData is now: %@", jsonData);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    
    NSLog(@"Did finish loading");
    
    NSLog(@"JSON Data: %@", jsonData);
    
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    
    NSArray *abc = [decoder objectWithData:jsonData];
        
    NSLog(@"res %@", abc);
    
    [NSJS]
    
    
}

- (void)connection:(NSURLConnection *)conn DidFailWithError:(NSError *)err
{
    NSLog(@"Did fail with error: %@", err);
}

@end
