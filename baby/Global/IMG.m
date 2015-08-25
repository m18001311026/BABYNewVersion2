//
//  IMG.m
//  baby
//
//  Created by zhang da on 14-3-17.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "IMG.h"
#import "Constants.h"
#import "NSStringExtra.h"

#import "ImageTask.h"
#import "TaskQueue.h"


static NSMutableDictionary *cache;

@implementation IMG

+ (void)createDirection {
    NSString *imgPath = [NSTemporaryDirectory() stringByAppendingString:IMAGE_CACHE_FOLDER];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imgPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:imgPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
}

+ (void)resetCache {
    NSString *imgPath = [NSTemporaryDirectory() stringByAppendingString:IMAGE_CACHE_FOLDER];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:imgPath
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:nil];
}

+ (NSString *)imageDiskDir:(NSString *)url {
    NSString *fUrl = [url URLEncodedString];
    return [NSTemporaryDirectory() stringByAppendingFormat:@"%@/%@", IMAGE_CACHE_FOLDER, fUrl];
}

+ (void)getImage:(NSString *)url callback:(ImageDone)callback {
    UIImage *image = [self getImageFromMem:url];
    if (!image) {
        [self getImageFromDisk:url callback:^(NSString *rUrl, UIImage *image) {
            if (image) {
                if (callback) {
                    callback(url, image);
                }
            } else {
                [self getImageFromNetwork:url callback:^(NSString *rUrl, UIImage *image) {
                    if (callback) {
                        callback(url, image);
                    }
                }];
            }
        }];
    } else {
        callback(url, image);
    }
}

+ (UIImage *)getImageFromMem:(NSString *)url {
    if (cache && cache.count) {
        NSString *fUrl = [url URLEncodedString];
        return [cache objectForKey:fUrl];
    }
    return nil;
}

+ (UIImage *)getImageFromDisk:(NSString *)url {
    UIImage *image = [[[UIImage alloc] initWithContentsOfFile:[self imageDiskDir:url]] autorelease];
    [self saveImageToMem:image withUrl:url];
    return image;
}

+ (void)getImageFromDisk:(NSString *)url callback:(ImageDone)callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        UIImage *img = [[[UIImage alloc] initWithContentsOfFile:[self imageDiskDir:url]] autorelease];
        [self saveImageToMem:img withUrl:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(url, img);
            }
        });
    });
}

+ (void)getImageFromNetwork:(NSString *)url callback:(ImageDone)callback {
    ImageTask *task = [[ImageTask alloc] initGetImage:url];
    task.logicCallbackBlock = ^(bool succeeded, id userInfo) {
        if (succeeded) {
            UIImage *img = (UIImage *)[userInfo objectForKey:@"image"];
            [self saveImage:img withUrl:url sync:NO];
            
            NSLog(@"gallery pic is %@",[userInfo objectForKey:@"image"]);
            
            
            if (callback) {
                callback(url, img);
            }
        } else {
            if (callback) {
                callback(url, nil);
            }
        }
    };
    [TaskQueue addTaskToQueue:task];
    [task release];
}

+ (void)saveImageToMem:(UIImage *)image withUrl:(NSString *)url {
    if (image.size.width*image.size.height < IMAGE_SIZE_THREADHOLD) {
        if (cache.count < IMAGE_CAHCE_MAX) {
            @synchronized([IMG class])
            {
                [cache removeAllObjects];
            }
        }
        NSString *fUrl = [url URLEncodedString];
        if (image) {
            @synchronized([IMG class]) {
                [cache setObject:image forKey:fUrl];
                //chulijian
             //   NSLog(@"image is exist then fUrl:%@",fUrl);
             //   NSLog(@"image is exist then url:%@",url);

              //  NSLog(@"loadingImage is%@",image);
                
                
                NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage* imagePp = [[UIImage alloc] initWithData:imageData];
                CGSize newSize = CGSizeMake(100, 100);
                UIGraphicsBeginImageContext( newSize );// a CGSize that has the size you want
                [imagePp drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                
                //image is the original UIImage
            //    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
             //   UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imagePp.size.width, imagePp.size.height)];
                float imageWidth=imagePp.size.width;
             //   NSLog(@"Width is %f",imageWidth);
                float imageHeight = imagePp.size.height;
            //    NSLog(@"Height is %f",imageHeight);
                
                NSString * strWidth=[NSString stringWithFormat:@"%f",imageWidth];
             //   NSLog(@"iiiiiiiiiiiiiii%@",strWidth);
                NSString * strHeight=[NSString stringWithFormat:@"%f",imageHeight];
             //   NSLog(@"wwwwwwwwwwwwwww%@",strHeight);

                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"zhousanyi" object:strWidth userInfo:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"zhousaner" object:strHeight userInfo:nil];
                if(imageHeight>imageWidth)
                {
                    NSString * str=@"2015-02-11 11:51:59";
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhousan" object:str userInfo:nil];
                   

                    NSLog(@"CCTT10");
                }
                
                
                //chulijianzhousan
                //[imageMain setImage:newImage];
                //img.image=newImage;
                [imageData release];
                //[img release];
                //[self.view addSubview:img];
                //chulijian

                
            }
        } else
        {
            NSLog(@"image is null: %@", fUrl);
        }
    }
}

+ (void)saveImage:(UIImage *)image withUrl:(NSString *)url sync:(bool)sync {
    if (!cache) {
        @synchronized([IMG class]) {
            if (!cache) {
                cache = [[NSMutableDictionary alloc] initWithCapacity:0];
            }
        }
    }
    
    NSString *imgPath = [self imageDiskDir:url];
    if (sync) {
        if ( ![UIImagePNGRepresentation(image) writeToFile:imgPath options:NSAtomicWrite error:nil] ) {
            NSLog(@"save error");
            [self createDirection];
        }
    } else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            if ( ![UIImagePNGRepresentation(image) writeToFile:imgPath options:NSAtomicWrite error:nil] ) {
                NSLog(@"save error");
                [self createDirection];
            }
        });
    }
    [self saveImageToMem:image withUrl:url];
}

@end
