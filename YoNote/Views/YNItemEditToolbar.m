//
//  YNItemEdit.m
//  YoNote
//
//  Created by Zchan on 15/5/11.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemEditToolbar.h"

@interface YNItemEditToolbar ()


@end

@implementation YNItemEditToolbar

- (void)setupViews {
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"YNItemEditToolbar" owner:self options:nil];
    self.YNItemEditToolbar = [subviewArray objectAtIndex:0];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (IBAction)touchDateCreatedButton:(id)sender {
    if (!_delegate) {
        NSLog(@"delegate is nil");
    } else {
        [_delegate pickDateCreated];
    }
    
}

- (IBAction)touchDateAlarmedButton:(id)sender {
    if (!_delegate) {
        NSLog(@"delegate is nil");
    } else {
        [_delegate pickDateAlarmed];
    }
}

- (IBAction)touchCollectionButton:(id)sender {
    if (!_delegate) {
        NSLog(@"delegate is nil");
    } else {
        [_delegate selectCollection];
    }

}
- (IBAction)touchTagsButton:(id)sender {
    if (!_delegate) {
        NSLog(@"delegate is nil");
    } else {
        [_delegate selectTags];
    }
}
- (IBAction)touchImageButton:(id)sender {
    if (!_delegate) {
        NSLog(@"delegate is nil");
    } else {
        [_delegate pickImages];
    }
}

@end
