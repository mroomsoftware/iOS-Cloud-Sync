//
//  AppDelegate.h
//  cloudComputing
//
//  Created by Minh Tuan on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteService.h"

@class LoginViewController;
@class MainViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *relinkUserId;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RemoteService *remoteService;
@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) LoginViewController *loginViewController;
@property (nonatomic, retain) MainViewController *mainViewController;

@end
