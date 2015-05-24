//
//  YNImageTransformer.m
//  YoNote
//
//  Created by Zchan on 15/5/23.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNImageTransformer.h"

@implementation YNImageTransformer

+ (Class)transformedValueClass
{
    return [UIImage class];
}

- (id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}


@end
