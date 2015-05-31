//
//  YNImageStore.h
//  YoNote
//
//  Created by Zchan on 15/5/7.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface YNImageStore : NSObject

@property (nonatomic, strong) NSString *imgPath;

+ (instancetype)sharedStore;


- (void)saveImages:(NSArray *)assets;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

- (UIImage *)getfullResolutionImage:(ALAsset *)asset;
- (UIImage *)imageForKey:(NSString *)key;
- (UIImage *)setThumbnailFromImage:(UIImage *)image newRect:(CGRect)newRect;
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

- (NSArray *)getImageNames:(NSArray *)assets;


@end
