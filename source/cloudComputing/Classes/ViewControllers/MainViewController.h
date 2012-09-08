//
//  MainViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "RemoteService.h"

@class AppDelegate;

@interface MainViewController : UIViewController<DBRestClientDelegate, RemoteServiceDelegate>{
    AppDelegate *appDel;
    DBRestClient *restClient;
}
- (IBAction)btnPhotos_Click:(id)sender;
- (IBAction)btnNotes_Click:(id)sender;
- (IBAction)btnVoices_Click:(id)sender;

@end
