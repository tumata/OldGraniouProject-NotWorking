//
//  NSString+DecodeToImage.m
//  GraniouProject
//
//  Created by Philippe Tumata on 12/05/2014.
//  Copyright (c) 2014 telecom. All rights reserved.
//

#import "NSString+DecodeToImage.h"

@implementation NSString (DecodeToImage)

- (UIImage *)decodeBase64ToImage
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
