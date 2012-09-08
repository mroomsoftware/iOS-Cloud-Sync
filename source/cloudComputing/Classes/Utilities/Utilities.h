//
//  Utilities.h
//  cloudComputing
//
//  Created by Minh Tuan on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+ (void)showMsg:(NSString *)strMessage andTitle:(NSString *)strTitle;
+ (UIImage*)imageByScaling:(UIImage *)image;
+ (void)writeFile_data:(NSData *)data fileName:(NSString *)fileName intoPath:(NSString *)localPath;
+ (NSString *)documentsPathForFileName:(NSString *)name folder:(NSString *)folder;
+ (NSString *)initFileName;
@end
