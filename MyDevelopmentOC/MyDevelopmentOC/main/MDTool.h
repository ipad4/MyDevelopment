//
//  MDTool.h
//  MyDevelopmentTest
//
//  Created by hanyfeng on 15/2/16.
//  Copyright (c) 2015年 hanyfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDTool : NSObject

/**
 *  把plist文件转换成数组返回
 *
 *  @param plistName plist文件名称
 *
 *  @return 转换后的数组
 */
+(NSArray *)getPlistDataByName:(NSString *)plistName;

/**
 *  获取 输出指定文字内容所需的size
 *
 *  @param content  文字内容
 *  @param fontSize 字号
 *  @param width    允许显示的最大宽度，传0代表不限制
 *  @param height   允许显示的最大高度，传0代表不限制
 *
 *  @return 输出指定文字内容所需的size
 */
+(CGSize)getStringSizeWithString:(NSString *)content
                         andFont:(float)fontSize
                        andWidth:(float)width andHeight:(float)height;

/**
 *  屏幕宽度
 *
 *  @return 屏幕宽度
 */
+(CGFloat)screenWidth;

/**
 *  屏幕高度
 *
 *  @return 屏幕高度
 */
+(CGFloat)screenHeight;

/**
 *  自适应导航的高度
 *
 *  @return 高度
 */
+(CGFloat)navigationBarHeight;

/**
 *  设置rect
 *
 *  @param x x
 *  @param y y
 *  @param w w
 *  @param h h
 *
 *  @return rect
 */
+(CGRect)setRectX:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
@end
