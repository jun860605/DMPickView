//
//  DMPickView.h
//  DMPickView
//
//  Created by 郑军 on 2017/9/26.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMBasePickView.h"
typedef void (^DMConfirmBlock)(NSString *str) ;
@interface DMPickView : UIView
//显示的内容
@property (nonatomic , copy) NSString *title ;
//选项
@property (nonatomic , strong) NSArray *pickArray ;
//展示的pickview的类型 （是时间控制器还是选择项）
@property (nonatomic , assign) BOOL showTimeView ;
//展示的pickview
@property (nonatomic , strong) DMBasePickView *pickView ;
//向下的视图
@property (nonatomic , strong) UIImage *pickImage ;
//点击确定按钮
@property (nonatomic , strong) DMConfirmBlock confirmHandler ;
@end
