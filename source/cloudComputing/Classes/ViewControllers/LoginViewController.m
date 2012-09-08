//
//  LoginViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "MainViewController.h"

@interface LoginViewController ()
- (void)updateButtons;
- (void)createUI;
@end

@implementation LoginViewController
@synthesize mainView = _mainView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithTitle:@"MainView" style:UIBarButtonItemStylePlain 
                                               target:self action:@selector(openMainView)] autorelease];
    self.title = @"Link Account";
    [self updateButtons];
}

- (void)viewDidUnload
{
    [btnLink release];
    btnLink = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_mainView release];
    [btnLink release];
    [super dealloc];
}

#pragma mark - private function
- (void)updateButtons {
    NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    [btnLink setTitle:title forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
}

- (void)createUI{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgLoginView.png"]]];
}

- (IBAction)btnLinkClick:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
		[[DBSession sharedSession] link];
    } else {
        [[DBSession sharedSession] unlinkAll];
        [[[[UIAlertView alloc] 
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
        [self updateButtons];
    }
}

- (void)openMainView{
    MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:mainView animated:YES];
    [mainView release];
}

@end
