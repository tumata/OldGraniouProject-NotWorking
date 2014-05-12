//
//  UIImage+EncodeImageToBase64String.m
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 29/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "UIImage+EncodeImageToBase64String.h"

@implementation UIImage (EncodeImageToString)

- (NSString *)encodeImageToBase64: (CGFloat)jpegCompression
{
    return [UIImageJPEGRepresentation(self, jpegCompression) base64EncodedStringWithOptions:0];
}

@end

@implementation NSString (DecodeToImage)

- (UIImage *)decodeBase64ToImage
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
