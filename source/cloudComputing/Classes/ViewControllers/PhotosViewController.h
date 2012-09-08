//
//  PhotosViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteService.h"
#import <QuartzCore/QuartzCore.h>

@class AppDelegate;

@interface PhotosViewController : UIViewController<UITableViewDataSource, RemoteServiceDelegate, UIActionSheetDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UITableView *tbvContent;
    
    UIImagePickerController *pkControl;
    
    AppDelegate *appDel;
    NSMutableArray *arrData;

}

@end
