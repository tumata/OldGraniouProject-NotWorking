//
//  UIImage+EncodeImageToString.m
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "UIImage+EncodeImageToString.h"

@implementation UIImage (EncodeImageToString)

- (NSString *)encodeImageToBase64: (CGFloat)jpegCompression
{
    return [UIImageJPEGRepresentation(self, jpegCompression) base64EncodedStringWithOptions:0];
}

@end
