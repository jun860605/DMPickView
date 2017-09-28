//
//  DMBasePickView.h
//  DMPickView
//
//  Created by 郑军 on 2017/9/26.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ConfirmHandler)(NSString *str) ;
typedef void (^CancleHandler)(void);
typedef void (^DismissCompared)(void);
@interface DMBasePickView : UIView
//点击确认按钮的回调
@property (nonatomic , strong) ConfirmHandler confirmHandler ;
//点击取消按钮的回调
@property (nonatomic , strong) CancleHandler cancleHandler ;
//pickView收起的回调
@property (nonatomic , strong) DismissCompared dismissCompared ;
//分组的数组
@property (nonatomic , strong) NSMutableArray *componentArray ;
//添加的pickview
@property (nonatomic , strong) UIPickerView *pickView ;
//时间控件
@property (nonatomic , strong) UIPickerView *dataPickView ;
//显示的数组
@property (nonatomic , strong) NSArray *plistArray ;
//选中的位置
@property (nonatomic , strong) NSMutableDictionary *indexParam ;
//默认选择的数组
@property (nonatomic,strong) NSArray *chooseIndex ;
//picklist中的元素是不是数组
@property(nonatomic,assign)BOOL isLevelArray;
//picklist中的元素是不是字符串
@property(nonatomic,assign)BOOL isLevelString;
//picklist中的元素是不是字典
@property(nonatomic,assign)BOOL isLevelDic;
//所选的文字
@property(nonatomic,copy)NSString *resultString ;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *
 *  @return 带有toolbar的pickview
 */
-(instancetype)initPickviewWithArray:(NSArray *)array;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate               默认选中时间
 *
 *  @return 带有toolbar的datePicker
 */
-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler;
/**
 *  显示本控件
 */
-(void)show;
/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color;
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color;
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color;

- (void)setTitleFont:(float)fontSize ;

//设置最大的日期
- (void)setDatePickerMaxDate:(NSDate *)date;

//设置最小日期
- (void)setDatePickerMinDate:(NSDate *)date;
//设置各个类型
-(void)setArrayClass:(NSArray *)array ;
@end
