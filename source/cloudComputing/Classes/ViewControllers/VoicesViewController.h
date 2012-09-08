//
//  VoicesViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteService.h"
#import "BaseViewController.h"

@class AppDelegate;
@interface VoicesViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, RemoteServiceDelegate>
{
    IBOutlet UITableView *tbvContent;
    AppDelegate *appDel;
}

@property (nonatomic, retain) NSMutableArray *arrData;

@end
