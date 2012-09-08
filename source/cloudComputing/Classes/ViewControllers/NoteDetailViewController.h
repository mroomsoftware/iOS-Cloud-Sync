//
//  NoteDetailViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteService.h"

@protocol NoteDetailDelegate <NSObject>
- (void)uploadNoteSuccess:(NSString *)pathFile;
@end

@class AppDelegate;

@interface NoteDetailViewController : UIViewController<RemoteServiceDelegate>{
    IBOutlet UITextView *txvContent;
    AppDelegate *appDel;
}
@property (nonatomic, assign) id<NoteDetailDelegate> delegate;
@property (nonatomic, retain) NSString *strPathFile;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isAddNewNote:(BOOL)addNew;

@end
