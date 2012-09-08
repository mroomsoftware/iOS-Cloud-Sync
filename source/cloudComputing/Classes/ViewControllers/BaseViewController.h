//
//  BaseViewController.h
//  cloudComputing
//
//  Created by Trong Dinhm on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BaseViewController : UIViewController
{
@private
    UIActivityIndicatorView* indicaterLoading;
	UIView *hudView;
    
@public
    BOOL isRunning;
}

- (void) startWaitingMode;
- (void) endWatingMode;

@end
