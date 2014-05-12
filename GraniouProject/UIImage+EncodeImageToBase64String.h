//
//  UIImage+EncodeImageToBase64String.h
//  Graniou Project Monitoring
//
//  Created by Philippe Tumata on 29/04/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (EncodeImageToString)

- (NSString *)encodeImageToBase64: (CGFloat)jpegCompression;

@end

@interface NSString (DecodeToImage)

- (UIImage *)decodeBase64ToImage;

@end