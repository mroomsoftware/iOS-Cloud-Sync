//
//  MainViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "PhotosViewController.h"
#import "NotesViewController.h"
#import "VoicesViewController.h"

@interface MainViewController()

- (void)initObjects;
- (void)createUI;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDel.remoteService.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initObjects];
    [self createUI];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - RemoteServiceDelegate
- (void)uploadFile_success:(NSString *)srcPath{

}

- (void)uploadFile_failed:(NSError *)error{

}

- (void)loadMetadata_success:(DBMetadata *)metadata{
    for (DBMetadata *file in metadata.contents) {
        NSLog(@"\t%@", file.filename);
    }
}

- (void)loadMetadata_failed:(NSError *)error{

}

#pragma mark - private functions
- (void)initObjects{
    
}

- (void)createUI{

}

- (IBAction)btnPhotos_Click:(id)sender {
    PhotosViewController *photoView = [[PhotosViewController alloc] initWithNibName:@"PhotosViewController" bundle:nil];
    [self.navigationController pushViewController:photoView animated:YES];
    [photoView release];
        
}

- (IBAction)btnNotes_Click:(id)sender {
    NotesViewController *notesView = [[NotesViewController alloc] initWithNibName:@"NotesViewController" bundle:nil];
    [self.navigationController pushViewController:notesView animated:YES];
    [notesView release];
}

- (IBAction)btnVoices_Click:(id)sender {
    VoicesViewController *voicesView = [[VoicesViewController alloc] initWithNibName:@"VoicesViewController" bundle:nil];
    [self.navigationController pushViewController:voicesView animated:YES];
    [voicesView release];
}
@end
