//
//  NSString+TypeseHelper.h
//
//  Created by 苏沫离 on 2017/7/22.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///文字排版
@interface NSString (TypeseHelper)

///开始测试排版
+ (void)th_startTypeseter;

///文字排版
- (NSString *)th_typesettingString;

///文字排版
- (NSString *)th_typesettingString_1;


+ (NSString *)th_getSectionContent;

@end

NS_ASSUME_NONNULL_END

