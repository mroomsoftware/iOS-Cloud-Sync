//
//  VoicesViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoicesViewController.h"
#import "VoiceCell.h"
#import "SpeakHereViewController.h"

#import "AppDelegate.h"

@interface VoicesViewController ()
- (void)initNavigationController;
- (BOOL)checkExitingFile:(DBMetadata *)file;
@end

@implementation VoicesViewController
@synthesize arrData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startWaitingMode];
    appDel.remoteService.delegate = self;
    [appDel.remoteService loadMetadata_dropboxPath:@"/Voices"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initObjects];
    [self initNavigationController];
    
    
}

- (void)viewDidUnload
{
    [tbvContent release];
    tbvContent = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
#pragma mark - Objects

- (void)initObjects
{
    self.arrData = [[[NSMutableArray alloc] init] autorelease];
    
    UIView *vwUploadPhoto = [[UIView alloc] initWithFrame:CGRectMake(0, 374, 320, 44)];
    [vwUploadPhoto setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgViewCheckOut = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bgViewCheckOut setBackgroundColor:[UIColor blackColor]];
    [bgViewCheckOut setAlpha:0.8];
    [vwUploadPhoto addSubview:bgViewCheckOut];
    [bgViewCheckOut release];
    
    UIImage *imgBgButton = [[UIImage imageNamed:@"bgButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    UIButton *btnCheckOut = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCheckOut setFrame:CGRectMake(10, 5, 300, 34)];
    [btnCheckOut setTitle:@"Upload voice" forState:UIControlStateNormal];
    [btnCheckOut.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
    [btnCheckOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCheckOut setBackgroundImage:imgBgButton forState:UIControlStateNormal];
    [btnCheckOut addTarget:self action:@selector(btnUploadVoice_Click:) forControlEvents:UIControlEventTouchUpInside];
    [vwUploadPhoto addSubview:btnCheckOut];
    
    [self.view addSubview:vwUploadPhoto];
    [vwUploadPhoto release];
}

#pragma mark - Functions

- (void)initNavigationController{
    //Init title view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = @"Voice Memos";
    [label sizeToFit];
}

- (BOOL)checkExitingFile:(DBMetadata *)file{
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Voices"], file.filename];
    NSData *imgData = [[[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathFile]] autorelease];
    if (file.totalBytes == imgData.length){
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"VoiceCell";
    VoiceCell *cell =  (VoiceCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *arr_top = [[NSBundle mainBundle]loadNibNamed:@"VoiceCell" owner:self options:nil];
        cell = [arr_top objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSArray *parts = [[self.arrData objectAtIndex:indexPath.row] componentsSeparatedByString:@"/"];
    [cell.textLabel setText:[parts objectAtIndex:[parts count]-1]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RemoteSeviceDelegate
- (void)loadMetadata_success:(DBMetadata *)metadata{
    for (DBMetadata *file in metadata.contents){
        if([self checkExitingFile:file]){   //File exit
            NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Voices"], file.filename];
            [arrData addObject:pathFile];
            [tbvContent reloadData];
            
            [self endWatingMode];
            
        }else { //file not exit => Down load photo to local
            NSString *pathFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Voices"];
            NSError *error;
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:pathFile])
                [[NSFileManager defaultManager] createDirectoryAtPath:pathFile withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
            
            [appDel.remoteService loadFile_dropboxPath:[NSString stringWithFormat:@"/Voices/%@", file.filename] intoPath:[NSString stringWithFormat:@"%@/%@", pathFile, file.filename]];
        }
    }
}

- (void)loadMetadata_failed:(NSError *)error
{
    [self endWatingMode];
}

- (void)loadFile_failed:(NSError *)error
{
    [self endWatingMode];
}

- (void)loadFile_success_localPath:(NSString*)pathFile{
    [self endWatingMode];
    [self.arrData addObject:pathFile];
    [tbvContent reloadData];
}

#pragma mark - Selector methods
- (void)btnUploadVoice_Click:(id)sender
{
    SpeakHereViewController *vcSpeakHere = [[SpeakHereViewController alloc] initWithNibName:@"SpeakHereViewController" bundle:nil];
    [self.navigationController pushViewController:vcSpeakHere animated:YES];
    [vcSpeakHere release];
}

#pragma mark - dealloc
- (void)dealloc {
    [tbvContent release];
    [super dealloc];
}
@end
