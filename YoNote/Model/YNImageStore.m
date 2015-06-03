//
//  YNImageStore.m
//  YoNote
//
//  Created by Zchan on 15/5/7.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNImageStore.h"

@interface YNImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;  // 存储照片

- (NSString *)imagePathForKey:(NSString *)key;  // 返回以key命名图片的图片存储路径

@end

@implementation YNImageStore

+ (instancetype)sharedStore
{
    static YNImageStore *sharedStore;
    
    //  为了保证在多线程应用中只创建一次对象
    //  创建线程安全的单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// No one should call init
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[YNImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
        
    }
    
    return self;
}

- (NSString *)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:key];
    return imagePath;
}

- (UIImage *)getfullResolutionImage:(ALAsset *)asset {
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    UIImage *fullResolutionImage =
    [UIImage imageWithCGImage:representation.fullResolutionImage
                        scale:1.0f
                  orientation:(UIImageOrientation)representation.orientation];

    return fullResolutionImage;
}

//  保存图片
- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
    self.dictionary[key] = image;
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:key];
        
    // Turn image into JPEG data
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    // Write it to full path
    [data writeToFile:imagePath atomically:YES];
}

- (void)saveImages:(NSArray *)assets {
    NSMutableArray *imagesNames = [NSMutableArray array];
    
    for (ALAsset *asset in assets) {
        [imagesNames addObject:[[asset defaultRepresentation] filename]];
    }
    
    // Save image to Documents
    for (int i = 0; i < assets.count; i++) {
        NSString *imageName = imagesNames[i];
        ALAsset *asset = assets[i];
        /*ALAssetRepresentation *representation = [assets[i] defaultRepresentation];
        
        UIImage *fullResolutionImage =
        [UIImage imageWithCGImage:representation.fullResolutionImage
                            scale:1.0f
                      orientation:(UIImageOrientation)representation.orientation];*/
        UIImage *fullResolutionImage = [self getfullResolutionImage:asset];
        
        [self setImage:fullResolutionImage forKey:imageName];
    }

}

//  读取指定图片
- (UIImage *)imageForKey:(NSString *)key
{
    // If possible, get it from the dictionary
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imagePath = [self imagePathForKey:key];
        
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:imagePath];
        
        // If we found an image on the file system, place it into the cache
        if (result) {
            self.dictionary[key] = result;
        } else {
            NSLog(@"Error: unable to find %@", imagePath);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
    
    NSString *imagePath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath
                                               error:NULL];
}

- (UIImage *)setThumbnailFromImage:(UIImage *)image newRect:(CGRect)newRect
{
    CGSize origImageSize = image.size;
    
    // Set thumbnail's size
    //CGRect newRect = kItemImageRect;
    
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:0.5];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (NSArray *)getImageNames:(NSArray *)assets {
    NSMutableArray *imageNames = [NSMutableArray array];
    
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *imageRep = [asset defaultRepresentation];
        [imageNames addObject:[imageRep filename]];
    }
    
    return imageNames;
}

@end
