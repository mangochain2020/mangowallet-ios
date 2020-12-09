//
//  AMSaveFile.m
//  AdMoProduct
//
//  Created by Frued on 2018/8/1.
//  Copyright © 2018年 Frued. All rights reserved.
//

#import "AMSaveFile.h"

@implementation AMSaveFile
+ (void)SaveImage:(UIImage*)image imageName:(NSString*)imageName {
    NSString *filetype = [imageName componentsSeparatedByString:@"."].lastObject;
    NSData *imageData = nil;
    if ([filetype isEqualToString:@"png"]) {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image, 0);
    }
    //获取沙盒路径
    NSString *fullPath = [kPathCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    BOOL result = [imageData writeToFile:fullPath atomically:YES];
    
    if (result == YES) {
        NSLog(NSLocalizedString(@"保存成功", nil));
    }else{
        NSLog(NSLocalizedString(@"保存失败", nil));
    }

}

+ (UIImage*)GetImage:(NSString*)imagename{
    //读取图片
    NSString *fullPath = [kPathCache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imagename]];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    return savedImage;
}

+ (BOOL)deleteImage:(NSString*)imagename {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //文件名
    NSString *uniquePath=[kPathCache stringByAppendingPathComponent:imagename];
    BOOL isExit =[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (! isExit) {
        NSLog(NSLocalizedString(@"文件不存在！", nil));
    }else {
        BOOL isDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (isDele)
            return YES;
    }
    return NO;
}

+ (long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path])
    {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    
    return 0;
}

+ (long long)folderSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    long long folderSize = 0;
    
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fileAbsolutePath])
            {
                long long size = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    
    return folderSize;
}
/*
 sanBoxPath取值为沙盒根目录：kPathCache等
 */
+ (void)deleteAllFileInPath:(NSString*)sanBoxPath{
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:sanBoxPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[kPathCache stringByAppendingPathComponent:fileName] error:nil];
    }
}

@end
