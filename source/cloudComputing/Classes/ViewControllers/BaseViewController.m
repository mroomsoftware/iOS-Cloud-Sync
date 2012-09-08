//
//  BaseViewController.m
//  cloudComputing
//
//  Created by Trong Dinh on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Indicator
- (void) startWaitingMode {
    isRunning = YES;
	@synchronized (self) {
		if (indicaterLoading==nil) {
			
			hudView = [[UIView alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
			hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
			hudView.clipsToBounds = YES;
			hudView.layer.cornerRadius = 10.0;

            indicaterLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			indicaterLoading.frame = CGRectMake(32, 32, indicaterLoading.bounds.size.width, indicaterLoading.bounds.size.height);
			[hudView addSubview:indicaterLoading];
			[indicaterLoading startAnimating];
			[self.view addSubview:hudView];
			[indicaterLoading release];
			[hudView release];
        }
	}
}

- (void) endWatingMode {
    isRunning = NO;
	@synchronized (self) {
		[indicaterLoading stopAnimating];
		[indicaterLoading setHidden:YES];
		[indicaterLoading removeFromSuperview];
		[hudView setHidden:YES];
		[hudView removeFromSuperview];
		indicaterLoading = nil;
		hudView = nil;
	}
}

@end
