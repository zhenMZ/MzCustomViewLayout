//
//  NSData+AES256.h
//  XilianApp
//
//  Created by MZ on 2017/5/3.
//  Copyright © 2017年 Chongqing Xilian Technology Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSData (AES256)

-(NSData *)aes256_encrypt:(NSString *)key;
-(NSData *)aes256_decrypt:(NSString *)key;

@end
