//
//  LingDianParser.m
//  YLRead
//
//  Created by 苏沫离 on 2020/7/12.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )


#import "LingDianParser.h"
#import "YLReadParser.h"

@implementation LingDianParser

+ (NSString *)saveFileDictByBookID:(NSString *)bookID{
    return [NSString stringWithFormat:@"%@/Documents/%@_dict",NSHomeDirectory(),bookID];
}

+ (NSString *)saveFileStringByBookID:(NSString *)bookID{
    return [NSString stringWithFormat:@"%@/Documents/%@_string",NSHomeDirectory(),bookID];
}

/** 获取小说的纯文本
 */
+ (NSMutableString *)getBookAllStringByBookID:(NSString *)bookID{
    NSMutableString *allString = [[NSMutableString alloc] init];
    NSMutableArray<NSMutableDictionary *> *catalogue = [self getCatalogueByBookID:bookID];
    [catalogue enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull dict, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *content = [NSString stringWithFormat:@"\n %@ \n\n %@",dict[@"sectionName"],dict[@"sectionContent"]];
        [allString appendString:content];
    }];
    NSString *filepath = [LingDianParser saveFileStringByBookID:bookID];
    [allString writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    SLog(@"allString === %@",allString);
    return allString;
}

/** 获取小说的章节与内容
 * 
 * <p><a style="" href="2152124.html">第0167章 平叛</a></p>
 * regula = @"(?<=\\<p> <a style=\"\" href=\").*?(?=\\</a></p>)";
 * @{@"sectionName":sectionName,@"sectionLink":sectionLink}
 */
+ (NSMutableArray<NSMutableDictionary *> *)getCatalogueByBookID:(NSString *)bookID{
    NSString *catalogueLink = [NSString stringWithFormat:@"https://m.lingdiankanshu.co/%@/all.html",bookID];
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:catalogueLink] encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [LingDianParser saveFileDictByBookID:bookID];
    NSMutableArray<NSMutableDictionary *> *catalogueArray = [NSMutableArray array];
    NSString *regula = @"(?<=\\<p> <a style=\"\" href=\").*?(?=\\</a></p>)";//根据正则表达式，取出章节标题、链接
    NSError *error;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regula options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray<NSTextCheckingResult *> *matches = [regularExpression matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    if (error) {
        NSLog(@"error === %@",error);
    }else{
        NSLog(@"count === %ld",matches.count);
        [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *matchString = [htmlString substringWithRange:obj.range];
            if ([matchString containsString:@"第"] &&
                [matchString containsString:@"章"]) {
                NSArray<NSString *> *array = [matchString componentsSeparatedByString:@"\">"];
                NSString *sectionName = array.lastObject;
                NSString *sectionLink = array.firstObject;
                NSString *sectionContent = [LingDianParser getSectionContentByLink:[NSString stringWithFormat:@"https://m.lingdiankanshu.co/%@/%@",bookID,sectionLink]];
                [catalogueArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"sectionName":sectionName,@"sectionLink":sectionLink,@"sectionContent":sectionContent}]];
                [catalogueArray writeToFile:path atomically:YES];
            }
        }];
    }
    SLog(@"catalogueArray === %@",catalogueArray);
    return catalogueArray;
}

/** 获取章节内容：根据章节链接
 * @param sectionLink 章节链接
 * @return 章节内容（纯文本）
 */
+ (NSString *)getSectionContentByLink:(NSString *)sectionLink{
    NSMutableString *sectionContent = [[NSMutableString alloc] init];
    NSString *regula = @"(?<=\\</div>\n</div>\n</div>).*?(?=\\</div>)";//根据正则表达式，取出指定文本
    NSString *sectionHTMLString;
    NSString *ling = [sectionLink copy];;
    int page = 1;
    do {
        ling = [NSString stringWithFormat:@"%@_%d.html",[sectionLink componentsSeparatedByString:@".html"].firstObject,page];
        NSLog(@"ling ===== %@",ling);
        sectionHTMLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:ling] encoding:NSUTF8StringEncoding error:nil];
        NSError *error;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regula options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray<NSTextCheckingResult *> *matches = [regularExpression matchesInString:sectionHTMLString options:0 range:NSMakeRange(0, [sectionHTMLString length])];
        if (error) {
            NSLog(@"error === %@",error);
        }else if(matches.count) {
            [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *matchString = [sectionHTMLString substringWithRange:obj.range];
                [sectionContent appendString:matchString];
            }];
        }else{
            NSLog(@"sectionHTMLString === %@",sectionHTMLString);
        }
        page++;
    } while ([sectionHTMLString containsString:@"下一页"]);
    NSString *result = [YLReadParser contentTypesettingWithContent:sectionContent];
    SLog(@"sectionContent === %@",result);
    return result;
}


@end
