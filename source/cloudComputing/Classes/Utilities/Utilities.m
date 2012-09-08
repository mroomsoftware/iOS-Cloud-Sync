//
//  Utilities.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void)showMsg:(NSString *)strMessage andTitle:(NSString *)strTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (UIImage*)imageByScaling:(UIImage *)image{
    return image;
}

+ (void)writeFile_data:(NSData *)data fileName:(NSString *)fileName intoPath:(NSString *)localPath{
    [data writeToFile:localPath atomically:YES];
}

+ (NSString *)documentsPathForFileName:(NSString *)name folder:(NSString *)folder
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", folder]];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [filePath stringByAppendingPathComponent:name]; 
}

+ (NSString *)initFileName{
    NSDate *newDate;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:~ NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    
    newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSDateFormatter *dateFormat3 = [[NSDateFormatter alloc] init];
    dateFormat3.dateFormat = @"yyyy-MM-dd hh.mm.ss";
    NSString *fileName = [NSString stringWithFormat:@"%@", [dateFormat3 stringFromDate:newDate]];
    [dateFormat3 release];
    
    return fileName;
}

//Method writes a string to a text file
-(void) writeToTextFile{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt", 
                          documentsDirectory];
    //create content - four lines of text
    NSString *content = @"One\nTwo\nThree\nFour\nFive";
    //save content to the documents directory
    [content writeToFile:fileName 
              atomically:NO 
                encoding:NSStringEncodingConversionAllowLossy 
                   error:nil];
    
}


//Method retrieves content from documents directory and
//displays it in an alert
-(void) displayContent{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt", 
                          documentsDirectory];
    NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
                                                    usedEncoding:nil
                                                           error:nil];
    //use simple alert from my library (see previous post for details)
//    [ASFunctions alert:content];
    [content release];
    
}

@end
