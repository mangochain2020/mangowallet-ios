//
//  AMSaveFile.h
//  AdMoProduct
//
//  Created by Frued on 2018/8/1.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSaveFile : NSObject
+ (void)SaveImage:(UIImage*)image imageName:(NSString*)imageName;
+ (UIImage*)GetImage:(NSString*)imagename;
+ (BOOL)deleteImage:(NSString*)imagename;
+ (long long)fileSizeAtPath:(NSString *)path;
+ (long long)folderSizeAtPath:(NSString *)path;
+ (void)deleteAllFileInPath:(NSString*)sanBoxPath;
@end
