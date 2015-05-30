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

- (UIImage *)getfullResolutionImage:(ALAsset *)asset;
- (void)saveImages:(NSArray *)assets;
- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;
- (UIImage *)setThumbnailFromImage:(UIImage *)image newRect:(CGRect)newRect;
- (NSArray *)getImageNames:(NSArray *)assets;


@end
