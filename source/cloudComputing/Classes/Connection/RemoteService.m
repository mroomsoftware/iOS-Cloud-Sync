//
//  RemoteService.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RemoteService.h"

@implementation RemoteService
@synthesize delegate;
@synthesize restClient;
- (id)init{
    self = [super init];
    if (self) {
        self.restClient = [self initRestClient];
    }
    return self;
}

- (DBRestClient *)initRestClient {
    if (!self.restClient) {
        self.restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
    }
    return self.restClient;
}

- (void)uploadFile_fileName:(NSString *)filename toDropboxPath:(NSString *)destDir fromLocalPath:(NSString *)localPath{
//    NSString *localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
//    NSString *filename = @"Info.plist";
//    NSString *destDir = @"/";
    [restClient uploadFile:filename toPath:destDir
             withParentRev:nil fromPath:localPath];
}

- (void)loadMetadata_dropboxPath:(NSString *)dropboxPath{
    [self.restClient loadMetadata:dropboxPath];
}

- (void)loadFile_dropboxPath:(NSString *)dropboxPath intoPath:(NSString *)localPath{
    [self.restClient loadFile:dropboxPath intoPath:localPath];
}

- (void)createFolder:(NSString *)folderName{
    [self.restClient createFolder:folderName];
}

#pragma mark - DBRestClientDelegate
//== Upload file ==
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    DLog(@"File uploaded successfully to path: %@", metadata.path);
    if([self.delegate respondsToSelector:@selector(uploadFile_success:)]) {
        [self.delegate uploadFile_success:srcPath];
    }
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    DLog(@"File upload failed with error - %@", error);
    if([self.delegate respondsToSelector:@selector(uploadFile_failed:)]) {
        [self.delegate uploadFile_failed:error];
    }

}

//== LoadMetadata ==
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    DLog(@"Load metadata success with path: %@", metadata.path);    
    if (metadata.isDirectory) {
        if([self.delegate respondsToSelector:@selector(loadMetadata_success:)]) {
            [self.delegate loadMetadata_success:metadata];
        }
        
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    DLog(@"Error loading metadata: %@", error);
    if([self.delegate respondsToSelector:@selector(loadMetadata_failed:)]) {
        [self.delegate loadMetadata_failed:error];
    }
}

//== Load file ==
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    DLog(@"File loaded into path: %@", localPath);
    if([self.delegate respondsToSelector:@selector(loadFile_success_localPath:)]) {
        [self.delegate loadFile_success_localPath:localPath];
    }
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    DLog(@"There was an error loading the file - %@", error);
    if([self.delegate respondsToSelector:@selector(loadFile_failed:)]) {
        [self.delegate loadFile_failed:error];
    }
}

//== Create Folder ==
// Folder is the metadata for the newly created folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    DLog(@"Created Folder Path %@",folder.path);
    DLog(@"Created Folder name %@",folder.filename);
}
// [error userInfo] contains the root and path
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    DLog(@"%@",error);
}



@end
