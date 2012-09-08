//
//  NotesViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDetailViewController.h"
#import "RemoteService.h"

@class AppDelegate;

@interface NotesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NoteDetailDelegate, RemoteServiceDelegate>{
    IBOutlet UITableView *tbvContent;
    
    AppDelegate *appDel;
    NSMutableArray *arrData;
    
}

@end
