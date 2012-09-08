//
//  PhotosViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosViewController.h"
#import "AppDelegate.h"
#import "PhotosCell.h"
#import "Utilities.h"

@interface PhotosViewController ()
- (void)initObjects;
- (void)initNavigationController;
- (void)takePicture;
- (void)loadImageForListView:(UIImage *)img;
- (BOOL)checkExitingFile:(DBMetadata *)file;
@end

@implementation PhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    [appDel.remoteService loadMetadata_dropboxPath:@"/Photos"];
//    [appDel.remoteService loadFile_dropboxPath:@"/Photos" intoPath:<#(NSString *)#>
    
//    [self loadImageForListView:nil];
}

- (void)viewDidUnload
{
    [tbvContent release];
    tbvContent = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc{
    [tbvContent release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ((arrData.count % 4) > 0) {
        return (arrData.count/4 + 1);
    }
    
    return [arrData count]/4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"PhotosCell";
    UIImage *img = nil;
    PhotosCell *cell =  (PhotosCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *arr_top = [[NSBundle mainBundle]loadNibNamed:@"PhotosCell" owner:self options:nil];
        cell = [arr_top objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.imv1.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [cell.imv1.layer setBorderWidth:1.0];
        cell.imv1.layer.masksToBounds = YES;
        
        [cell.imv2.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [cell.imv2.layer setBorderWidth:1.0];
        cell.imv2.layer.masksToBounds = YES;
        
        [cell.imv3.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [cell.imv3.layer setBorderWidth:1.0];
        cell.imv3.layer.masksToBounds = YES;
        
        [cell.imv4.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
        [cell.imv4.layer setBorderWidth:1.0];
        cell.imv4.layer.masksToBounds = YES;
        
        img = [UIImage imageNamed:@"image.jpg"];
    }
    
    if((indexPath.row * 4) < [arrData count])
    {
        [cell.imv1 setHidden:NO];
        NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row * 4];
        UIImage *imgLocal = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv1 setImage:imgLocal];
        
    }else {
        [cell.imv1 setHidden:YES];
    }
    
    if((indexPath.row * 4 + 1) < [arrData count])
    {
        [cell.imv2 setHidden:NO];
        NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row * 4 + 1];
        UIImage *imgLocal = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv2 setImage:imgLocal];
        
    }else {
        [cell.imv2 setHidden:YES];
    }
    
    if((indexPath.row * 4 + 2) < [arrData count])
    {
        [cell.imv3 setHidden:NO];
        NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row * 4 + 2];
        UIImage *imgLocal = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv3 setImage:imgLocal];
    }else {
        [cell.imv3 setHidden:YES];
    }
    
    if((indexPath.row * 4 + 3) < [arrData count])
    {
        [cell.imv4 setHidden:NO];
        NSString *pathFile = (NSString *)[arrData objectAtIndex:indexPath.row * 4 + 3];
        UIImage *imgLocal = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv4 setImage:imgLocal];
    }else {
        [cell.imv4 setHidden:YES];
    }
    
    return cell;
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    [picker dismissModalViewControllerAnimated:NO];
    UIImage *imgResult = [Utilities imageByScaling:img];
    [self loadImageForListView:imgResult];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
        [self takePicture];
		
    }else if (buttonIndex == 1) {
        [self loadPhotoFromLibrary];
		
    }
}

#pragma mark - RemoteSeviceDelegate
- (void)loadMetadata_success:(DBMetadata *)metadata{
    for (DBMetadata *file in metadata.contents){
        if([self checkExitingFile:file]){   //File exit
            NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"], file.filename];
            [arrData addObject:pathFile];
            [tbvContent reloadData];
            
        }else { //file not exit => Down load photo to local
            NSString *pathFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"];
            NSError *error;
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:pathFile])
                [[NSFileManager defaultManager] createDirectoryAtPath:pathFile withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
            
            [appDel.remoteService loadFile_dropboxPath:[NSString stringWithFormat:@"/Photos/%@", file.filename] intoPath:[NSString stringWithFormat:@"%@/%@", pathFile, file.filename]];
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

- (void)uploadFile_success:(NSString *)srcPath{
    
}

- (void)uploadFile_failed:(NSError *)error{

}

#pragma mark - Functions private
- (void)takePicture{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pkControl.sourceType   = UIImagePickerControllerSourceTypeCamera;
        pkControl.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//        pkControl.showsCameraControls = NO;
        [self presentModalViewController:pkControl animated:YES];
    }	
    else {			
        [Utilities showMsg:@"Camera unavailable" andTitle:@""]; 
    }
}

- (void)loadPhotoFromLibrary{
    pkControl.sourceType   = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:pkControl animated:YES];
}

- (void)loadImageForListView:(UIImage *)img{
    //== Create image name ==
//    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
//    
//    newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
//    NSDateFormatter *dateFormat3 = [[NSDateFormatter alloc] init];
//    dateFormat3.dateFormat = @"yyyy-MM-dd hh.mm.ss";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [Utilities initFileName]];
    DLog(@"fileName: %@", fileName);
    
    //== Save image to Document ==
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    NSString *photosPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:photosPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:photosPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@", photosPath, fileName];
    [imgData writeToFile:pathFile atomically:YES];  //Save image to Document
    
    //== Load image for list view ==
    [arrData addObject:pathFile];
    [tbvContent reloadData];
    
    //== Upload image to Dropbox ==
    [appDel.remoteService uploadFile_fileName:fileName toDropboxPath:@"/Photos" fromLocalPath:pathFile];
}

- (BOOL)checkExitingFile:(DBMetadata *)file{
    NSString *pathFile = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Photos"], file.filename];
    NSData *imgData = [[[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathFile]] autorelease];
    if (file.totalBytes == imgData.length){
        return YES;
    }
    return NO;
}

- (void)reloadCellAtIndex:(NSInteger)index with_pathFile:(NSString *)pathFile{
    PhotosCell *cell = (PhotosCell *)[tbvContent cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index/4 inSection:0]];
    if (index%4 == 0) {
        UIImage *img = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv1 setImage:img];
        
    }else if (index%4 == 1) {
        UIImage *img = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv2 setImage:img];
        
    }else if (index%4 == 2) {
        UIImage *img = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv3 setImage:img];
        
    }else if (index%4 == 3) {
        UIImage *img = [UIImage imageWithContentsOfFile:pathFile];
        [cell.imv4 setImage:img];
    }
    [cell reloadInputViews];
}

- (void)initNavigationController{
    //Init title view
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];    
    self.navigationItem.titleView = label;
    label.text = @"Photos";
    [label sizeToFit];  
}

- (void)initObjects{
    pkControl = [[UIImagePickerController alloc] init];
    [pkControl setDelegate:self];
    arrData = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    [btnCheckOut setTitle:@"Upload photo" forState:UIControlStateNormal];
    [btnCheckOut.titleLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
    [btnCheckOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCheckOut setBackgroundImage:imgBgButton forState:UIControlStateNormal];
    [btnCheckOut addTarget:self action:@selector(btnUploadPhoto_Click:) forControlEvents:UIControlEventTouchUpInside];
    [vwUploadPhoto addSubview:btnCheckOut];
    
    [self.view addSubview:vwUploadPhoto];
    [vwUploadPhoto release];
}

- (void)btnUploadPhoto_Click:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Upload photo" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Camera", @"Photo library", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

@end
