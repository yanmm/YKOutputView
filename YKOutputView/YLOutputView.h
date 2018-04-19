//
//  YLOutputView.swift
//  YLOutputView
//
//  Created by 焉知味 on 2018/4/19.
//  Copyright © 2018年 焉知味. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YLOutputViewDelegate <NSObject>
    
@required
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath;
    
@end

typedef void(^dismissWithOperation)(void);

typedef NS_ENUM(NSUInteger, YLOutputViewDirection) {
    kYLOutputViewDirectionLeft = 1,
    kYLOutputViewDirectionRight,
    kYLOutputViewDirectionCenter
};

@interface YLOutputView : UIView

@property (nonatomic, weak) id<YLOutputViewDelegate> delegate;
@property (nonatomic, strong) dismissWithOperation dismissOperation;
    
//初始化方法
//传入参数：模型数组，弹出原点，宽度，高度（每个cell的高度）
- (instancetype)initWithDataArray:(NSArray *)dataArray
                           origin:(CGPoint)origin
                            width:(CGFloat)width
                           height:(CGFloat)height
                        direction:(YLOutputViewDirection)direction;
    
//弹出
- (void)pop;
//消失
- (void)dismiss;
    
@end


@interface YLCellModel : NSObject
    
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *imageName; // 图片
@property (nonatomic, copy) UIFont *titleFont; // 标题大小
@property (nonatomic, copy) UIColor *titleColor; // 标题颜色
    
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName titleFont: (UIFont *)titleFont titleColor:(UIColor *)titleColor;
    
@end
