//
//  DMPickView.m
//  DMPickView
//
//  Created by 郑军 on 2017/9/26.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMPickView.h"
#import "Masonry.h"
@interface DMPickView () {
    // y 坐标
    float _currentY ;
    //ctr对应的view
    UIView *_baseView ;
    //最先的数据
    NSString *_defaultTitle ;
}
@property (nonatomic , strong) UIView *baseView ;
@property (nonatomic , assign) CGRect  baseViewFrame ;
@property (nonatomic , strong) UILabel *titleLabel ;
@end

@implementation DMPickView
- (instancetype)init {
    return [self initWithFrame:CGRectZero] ;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame] ;
    if (self) {
        _title = @"请选择" ;
        _showTimeView = NO ;
        _currentY = 0 ;
        _pickArray = @[] ;
        
        UILabel *titleLabel = ({
            UILabel *label = [[UILabel alloc] init] ;
            label.backgroundColor = [UIColor clearColor] ;
            label.text = _title ;
            label.textAlignment = NSTextAlignmentRight ;
            label.font = [UIFont systemFontOfSize:15] ;
            label.textColor = [UIColor colorWithRed:17/255.0 green:40/255.0 blue:74/255.0 alpha:1.0] ;
            label ;
        }) ;
        [self addSubview:titleLabel] ;
        _titleLabel = titleLabel ;
        
        UIImageView *downImageLogo = ({
            UIImageView *imageView = [[UIImageView alloc] init] ;
            imageView.image = [UIImage imageNamed:@"pickviewicon"] ;
            imageView.contentMode = UIViewContentModeScaleAspectFit ;
            imageView ;
        }) ;
        [self addSubview:downImageLogo] ;
        
        [downImageLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self) ;
            make.size.mas_equalTo(CGSizeMake(11, 6)) ;
            make.right.equalTo(self).offset(-5) ;
        }] ;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self) ;
            make.top.bottom.equalTo(self) ;
            make.right.equalTo(downImageLogo.mas_left).offset(-10) ;
        }] ;
        
        self.userInteractionEnabled = YES ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThePickView)] ;
        [self addGestureRecognizer:tap] ;
    }
    return self ;
}

/**
 *   展示pickview
 */
- (void)showThePickView {
    //回收键盘
    [self endEditing:YES] ;
    if (_showTimeView) {
        //展示时间控件
        
    }else {
        //展示一般的控件
        if (_pickArray.count == 0) {
            return ;
        }
       
        if (![self isContainPickView]) {
            _pickView = [[DMBasePickView alloc] initPickviewWithArray:_pickArray] ;
            [self setTheDefaultString] ;
            _pickView.chooseIndex = [self getIndexList] ;
            [_pickView show] ;
            __weak typeof(self) weakSelf = self ;
            _pickView.dismissCompared = ^{
                [UIView animateWithDuration:0.5 animations:^{
                    weakSelf.baseView.frame = weakSelf.baseViewFrame ;
                }] ;
            } ;
            _pickView.confirmHandler = ^(NSString *str) {
                weakSelf.title = str ;
                weakSelf.titleLabel.text = str ;
            } ;
            _currentY = 0 ;
            float currentY = [self getCurrentY:self] ;
            if (currentY + self.frame.size.height > _pickView.frame.origin.y) {
                //遮挡
                float distance = currentY + self.frame.size.height - _pickView.frame.origin.y ;
                [UIView animateWithDuration:0.5 animations:^{
                    CGRect windowFrame = _baseView.frame ;
                    windowFrame.origin.y -= distance ;
                    _baseView.frame = windowFrame ;
                }] ;
            }
        }else {
            NSLog(@"%@",_pickArray) ;
            [_pickView setArrayClass:_pickArray] ;
            [self setTheDefaultString] ;
            //刷新plistarray
            _pickView.plistArray = self.pickArray ;
            //重新设置所选中的位置
            _pickView.chooseIndex = [self getIndexList] ;
            //刷新pickview
            [_pickView.pickView reloadAllComponents] ;
            __weak typeof(self) weakSelf = self ;
            _pickView.confirmHandler = ^(NSString *str) {
                weakSelf.title = str ;
                weakSelf.titleLabel.text = str ;
            } ;
            if (_pickView.isLevelString) {
                [_pickView.pickView selectRow:[[_pickView.chooseIndex objectAtIndex:0] intValue] inComponent:0 animated:YES];
            }else if(_pickView.isLevelArray) {
                [_pickArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_pickView.pickView selectRow:[[_pickView.chooseIndex objectAtIndex:idx] intValue] inComponent:idx animated:YES];
                }] ;
            }
        }
    }
}

- (void)setTheDefaultString {
    if (_pickView.isLevelString) {
        if ([_pickArray containsObject:_title]) {
            _pickView.resultString = self.title ;
        }else {
            _pickView.resultString = [_pickArray objectAtIndex:0] ;
        }
    }else if (_pickView.isLevelArray) {
        _pickView.resultString = self.title ;
    }
}

/**
 获取选中的位置
 @return 选中的位置(chooseIndex)
 */
- (NSArray *)getIndexList {
    if (_pickView.isLevelString) {
        __block NSInteger index = 0 ;
        [_pickArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:_title]) {
                index = idx ;
            }
        }] ;
        return @[[NSString stringWithFormat:@"%ld",index]] ;
    }else if (_pickView.isLevelArray) {
        __block NSString *string =  _title;
        NSMutableArray *resultArr = [[NSMutableArray alloc] init] ;
        if ([string isEqualToString:@"请选择"] || string.length == 0) {
            [_pickArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [resultArr addObject:@"0"] ;
            }] ;
        }else {
            [_pickArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *array = obj ;
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *str = obj ;
                    if ([string hasPrefix:str]) {
                        [resultArr addObject:[NSString stringWithFormat:@"%ld",idx]] ;
                        string = [string stringByReplacingOccurrencesOfString:str withString:@""] ;
                    }
                }] ;
            }] ;
        }
        return resultArr ;
    }
    return @[] ;
}

/**
 在展示pickview之前先确认window是否已经有pickview，如果有直接刷新，没有的话就添加一个
 
 @return 是否已经存在pickview
 */
- (BOOL)isContainPickView {
    BOOL isContain = NO ;
    for (UIView *view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[DMBasePickView class]]) {
            _pickView = (DMBasePickView *)view ;
            isContain = YES ;
        }
    }
    return isContain ;
}


- (float)getCurrentY:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view ;
        _currentY = _currentY + view.frame.origin.y - scrollView.contentOffset.y ;
    }else {
        _currentY += view.frame.origin.y ;
    }
    UIView *superView = view.superview ;
    if ([superView isKindOfClass:[UIWindow class]]) {
        _baseView = view ;
        _baseViewFrame = view.frame ;
        return _currentY ;
    }else {
        [self getCurrentY:superView] ;
    }
    return _currentY ;
}

- (void)setTitle:(NSString *)title {
    _title = title ;
    _titleLabel.text = title ;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
