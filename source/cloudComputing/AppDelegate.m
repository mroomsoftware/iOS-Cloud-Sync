//
//  AppDelegate.m
//  cloudComputing
//
//  Created by Minh Tuan on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "Contants.h"

@interface AppDelegate () <DBSessionDelegate>
- (void)initObjects;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize remoteService = _remoteService;
@synthesize loginViewController = _loginViewController;
@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;

- (void)dealloc
{
    [_navController release];
    [_window release];
    [_remoteService release];
    [_loginViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initObjects];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
	NSInteger majorVersion = 
    [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] integerValue];
	if (launchURL && majorVersion < 4) {
		// Pre-iOS 4.0 won't call application:handleOpenURL; this code is only needed if you support
		// iOS versions 3.2 or below
		[self application:application handleOpenURL:launchURL];
		return NO;
	}
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[DBSession sharedSession] handleOpenURL:url]) {
		if ([[DBSession sharedSession] isLinked]) {
            DLog(@"App linked successfully!");
            
            //Create systems folder
            [self.remoteService createFolder:@"Photos"];
            [self.remoteService createFolder:@"Notes"];
            [self.remoteService createFolder:@"Voices"];
            
            MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self.navController pushViewController:mainView animated:YES];
            [mainView release];
		}
		return YES;
	}
	
	return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {
	relinkUserId = [userId retain];
	[[[[UIAlertView alloc] 
	   initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self 
	   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
	  autorelease]
	 show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	if (index != alertView.cancelButtonIndex) {
		[[DBSession sharedSession] linkUserId:relinkUserId];
	}
	[relinkUserId release];
	relinkUserId = nil;
}

#pragma mark - Private functions
- (void)initObjects{
    //== Init DBSession
    //    NSString* appKey = @"vvw744v6n4ihroq";
    //	NSString* appSecret = @"ek43t1s64f6eyel";
	NSString *root = kDBRootAppFolder;
    
    NSString* errorMsg = nil;
	if ([kAppKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app key correctly in DBRouletteAppDelegate.m";
        
    } else if ([kAppSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the app secret correctly in DBRouletteAppDelegate.m";
        
    } else if ([root length] == 0) {
		errorMsg = @"Set your root to use either App Folder of full Dropbox";
        
    } else {
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
		NSDictionary *loadedPlist = 
        [NSPropertyListSerialization 
         propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
		NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
		if ([scheme isEqual:@"db-APP_KEY"]) {
			errorMsg = @"Set your URL scheme correctly in DBRoulette-Info.plist";
		}
	}
	
	DBSession* session = 
    [[DBSession alloc] initWithAppKey:kAppKey appSecret:kAppSecret root:root];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
    [session release];
    
    DBSession* dbSession = [[[DBSession alloc]
                             initWithAppKey:kAppKey
                             appSecret:kAppSecret
                             root:kDBRootAppFolder] // either kDBRootAppFolder or kDBRootDropbox
                            autorelease];
    [DBSession setSharedSession:dbSession];
	
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
    
    //== Init remote service ==
    self.remoteService = [[RemoteService alloc] init];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    self.navController = [[[UINavigationController alloc] init] autorelease];
    
    if ([[DBSession sharedSession] isLinked]) {
        MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        self.navController.viewControllers = 
        [NSArray arrayWithObjects:loginView, mainView, nil];
        [loginView release];
        [mainView release];
        
    }else {
        self.navController.viewControllers = [NSArray arrayWithObjects:loginView, nil];
        [loginView release];
    }
    
    //== Init local folder ==
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Notes"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Voices"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    
}


@end
