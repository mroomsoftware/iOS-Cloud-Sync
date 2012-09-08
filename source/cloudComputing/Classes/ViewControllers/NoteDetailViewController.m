//
//  NoteDetailViewController.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface NoteDetailViewController ()
- (void)initObjects;
- (void)initNavigationController;
@end

@implementation NoteDetailViewController
@synthesize delegate;
@synthesize strPathFile;

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
}

- (void)viewDidUnload
{
    [txvContent release];
    txvContent = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [txvContent release];
    [super dealloc];
}

#pragma mark - RemoteSeviceDelegate
- (void)uploadFile_success:(NSString *)srcPath{
    [self.delegate uploadNoteSuccess:srcPath];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadFile_failed:(NSError *)error{
    
}

#pragma mark - functions private
- (void)initObjects{
    appDel.remoteService.delegate = self;
    if (strPathFile.length > 0) {
        NSData *myData = [NSData dataWithContentsOfFile:strPathFile]; 
        NSString* newStr = [[[NSString alloc] initWithData:myData
                                                  encoding:NSUTF8StringEncoding] autorelease];
        txvContent.text = newStr;
    }
}

- (void)initNavigationController{
    if (strPathFile.length == 0) {
        UIBarButtonItem *btnBarCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btnCancel_Click:)];
        self.navigationItem.leftBarButtonItem = btnBarCancel; 
        [btnBarCancel release];
        
        UIBarButtonItem *btnBarAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDone_Click:)];
        self.navigationItem.rightBarButtonItem = btnBarAdd; 
        [btnBarAdd release];
    
    }else {
        UIBarButtonItem *btnBarAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(btnDone_Click:)];
        self.navigationItem.rightBarButtonItem = btnBarAdd; 
        [btnBarAdd release];
            
    }
    
}

- (void)btnDone_Click:(id)sender{
    if (txvContent.text.length > 0) {
        if (strPathFile.length > 0) {
            //create content - four lines of text
            NSString *content = txvContent.text;
            //save content to the documents directory
            [content writeToFile:strPathFile 
                      atomically:NO 
                        encoding:NSStringEncodingConversionAllowLossy 
                           error:nil];
            
            NSRange range = [strPathFile rangeOfString:@"Notes/"];
            NSString *fileName = [strPathFile substringFromIndex:(range.location + range.length)];
            [appDel.remoteService uploadFile_fileName:fileName toDropboxPath:@"/Notes" fromLocalPath:strPathFile];
            
        }else {
            NSString *notesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Notes"];
            NSError *error;
            if (![[NSFileManager defaultManager] fileExistsAtPath:notesPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:notesPath withIntermediateDirectories:NO attributes:nil error:&error];
            
            //make a file name to write the data to using the documents directory:
            NSString *pathFile = [NSString stringWithFormat:@"%@/%@.txt", 
                                  notesPath, [Utilities initFileName]];
            //create content - four lines of text
            NSString *content = txvContent.text;
            //save content to the documents directory
            [content writeToFile:pathFile 
                      atomically:NO 
                        encoding:NSStringEncodingConversionAllowLossy 
                           error:nil];
            [appDel.remoteService uploadFile_fileName:[NSString stringWithFormat:@"%@.txt", [Utilities initFileName]] toDropboxPath:@"/Notes" fromLocalPath:pathFile];
        }
    }
}
- (void)btnCancel_Click:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}


@end
