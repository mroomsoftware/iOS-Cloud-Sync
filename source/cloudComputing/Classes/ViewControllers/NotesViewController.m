//
//  NotesViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"
#import "AppDelegate.h"

@interface NotesViewController ()
- (void)initObjects;
- (void)initNavigationController;
- (BOOL)checkExitingFile:(DBMetadata *)file;
@end

@implementation NotesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initObjects];
    [self initNavigationController];
    appDel.remoteService.delegate = self;
    [appDel.remoteService loadMetadata_dropboxPath:@"/Notes"];
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

- (void)dealloc {
    [tbvContent release];
    [super dealloc];
}

#pragma mark - RemoteSeviceDelegate
- (void)loadMetadata_success:(DBMetadata *)metadata{
    for (DBMetadata *file in metadata.contents){
        if([self checkExitingFile:file]){   //File exit
            NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Notes"], file.filename];
            [arrData addObject:pathFile];
            [tbvContent reloadData];
            
        }else { //file not exit => Down load photo to local
            NSString *pathFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Notes"];
            NSError *error;
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:pathFile])
                [[NSFileManager defaultManager] createDirectoryAtPath:pathFile withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
            
            [appDel.remoteService loadFile_dropboxPath:[NSString stringWithFormat:@"/Notes/%@", file.filename] intoPath:[NSString stringWithFormat:@"%@/%@", pathFile, file.filename]];
        }
    }
}

- (void)loadMetadata_failed:(NSError *)error{
    
}

- (void)loadFile_success_localPath:(NSString*)pathFile{
    [arrData addObject:pathFile];
    [tbvContent reloadData];
}

- (void)loadFile_failed:(NSError *)error{
    
}

#pragma mark - NoteDetailDelegate
- (void)uploadNoteSuccess:(NSString *)pathFile{
    BOOL exit = NO;
    for(NSString *strPath in arrData){
        if ([strPath isEqualToString:pathFile]) {
            exit = YES;
        }
    }
    if (!exit) {
        [arrData addObject:pathFile];
        [tbvContent reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell =  (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row];
    NSRange range = [pathFile rangeOfString:@"Notes/"];
    NSString *fileName = [pathFile substringFromIndex:(range.location + range.length)];
    [cell.textLabel setText:fileName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row];
    NoteDetailViewController *noteDetail = [[NoteDetailViewController alloc] initWithNibName:@"NoteDetailViewController" bundle:nil];
    noteDetail.strPathFile = pathFile;
    [self.navigationController pushViewController:noteDetail animated:YES];
    [noteDetail release];
}

#pragma mark - private functions
- (void)initObjects{
    arrData = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initNavigationController{
    //Init title view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];    
    self.navigationItem.titleView = label;
    label.text = @"Notes";
    [label sizeToFit];
    
//    UIButton *btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 31)];
//    [btnAdd setBackgroundImage:[UIImage imageNamed:@"menu_btn.jpg"] forState:UIControlStateNormal];
//    [btnAdd addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBarAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = btnBarAdd; 
//    [btnAdd release];
    [btnBarAdd release];
}
- (void)addNote:(id)sender{
    NoteDetailViewController *noteDetail = [[NoteDetailViewController alloc] initWithNibName:@"NoteDetailViewController" bundle:nil];
    noteDetail.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:noteDetail];
    [self presentModalViewController:navController animated:YES];
    [noteDetail release];
    [navController release];
}

- (BOOL)checkExitingFile:(DBMetadata *)file{
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Notes"], file.filename];
    NSData *imgData = [[[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathFile]] autorelease];
    if (file.totalBytes == imgData.length){
        return YES;
    }
    return NO;
}

@end
