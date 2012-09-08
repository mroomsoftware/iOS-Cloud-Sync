//
//  RemoteService.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol RemoteServiceDelegate <NSObject>
@optional
- (void)uploadFile_success:(NSString *)srcPath;
- (void)uploadFile_failed:(NSError *)error;
- (void)loadMetadata_success:(DBMetadata *)metadata;
- (void)loadMetadata_failed:(NSError *)error;
- (void)loadFile_success_localPath:(NSString*)localPath;
- (void)loadFile_failed:(NSError *)error;
@end

@interface RemoteService : NSObject<DBRestClientDelegate>{
    
}
@property (nonatomic, assign) id<RemoteServiceDelegate> delegate;
@property (strong, nonatomic) DBRestClient *restClient;

- (void)uploadFile_fileName:(NSString *)filename toDropboxPath:(NSString *)destDir fromLocalPath:(NSString *)localPath;
- (void)loadMetadata_dropboxPath:(NSString *)dropboxPath;
- (void)loadFile_dropboxPath:(NSString *)dropboxPath intoPath:(NSString *)localPath;
- (void)createFolder:(NSString *)folderName;

@end
