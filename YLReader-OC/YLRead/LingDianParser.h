//
//  LingDianParser.h
//  YLRead
//
//  Created by 苏沫离 on 2020/7/12.
//  Copyright © 2020 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//https://route.51mypc.cn/novels/search/牧神记
//https://route.51mypc.cn/novels/download/185607
//https://m.lingdiankanshu.co/445252/all.html

/** 零点看书小说网：提取小说文本内容
 * 牧神记：187917
 * 万族之劫 ： 445252    第719章 召集部将杀天王
 * 小阁老：421518        第六十八章 庆功
 * 赘婿：4626            第一〇三三章 捭阖 下
 * 重生之超级战舰   50314
 * 铁骨 21950
 * 全球高武 ： 343014
 * 大泼猴：5910
 * 人道至尊：3416
 * 明朝败家子：333717 
 * 马前卒：107884
 * 纵兵夺鼎：147913
 * 开海：410707
 * 完美世界：774
 * 官居一品：343736
 * 蓝白社：340799
 * 手术直播间：361130
 * 大将：106074
 * 将血：1237
 * 锦衣当国：51560
 *
 * 重生三国之我乃曹昂 ： 17108
 */
@interface LingDianParser : NSObject

/** 获取小说的纯文本
 *
 * &nbsp;&nbsp;&nbsp;&nbsp;
 */
+ (NSMutableString *)getBookAllStringByBookID:(NSString *)bookID;

/** 获取小说的章节与内容
 */
+ (NSMutableArray<NSMutableDictionary *> *)getCatalogueByBookID:(NSString *)bookID;

/** 获取章节内容：根据章节链接
 * @param sectionLink 章节链接
 * @return 章节内容（纯文本）
 */
+ (NSString *)getSectionContentByLink:(NSString *)sectionLink;

+ (void)textRegula;

@end

NS_ASSUME_NONNULL_END

/** 水儿*烟如梦隐 封灵师传奇
 * 第一部：《封灵师传奇：校园怪谈之宿舍有鬼》
 * 第二部：《封灵师传奇：校园怪谈之惊魂考场》
 * 第三部：《封灵师传奇：校园怪谈之阴谋》
 * 第四部：《封灵师传奇：奇谈Ⅰ封灵劫》
 * 第五部：《封灵师传奇：奇谈Ⅱ恐怖高校》
 * 番外第一部：《封灵师传奇：校园怪谈之恶灵游戏》
 * 番外第二部：《封灵师传奇：僵尸迷情》
 * 后传第一部：《最后的驱魔人：幽灵校舍》
 * 后传第二部：《最后的驱魔人：午夜碟仙》 https://m.lingdiankanshu.co/88346/all.html
 */



