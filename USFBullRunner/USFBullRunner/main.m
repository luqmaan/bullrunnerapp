//
//  main.m
//  USFBullRunner
//
//  Created by Lolcat on 31/01/2013.
//  Copyright (c) 2013 Createch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NUI/NUISettings.h>



#import "CRAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [NUISettings initWithStylesheet:@"Styles/Style"];
//        [NUISettings setAutoUpdatePath:@"/Users/lolcat/dev/bullrunnerapp/USFBullRunner/USFBullRunner/Styles/Style.nss"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CRAppDelegate class]));
    }
}
