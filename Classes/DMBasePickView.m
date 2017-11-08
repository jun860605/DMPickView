//
//  DMBasePickView.m
//  DMPickView
//
//  Created by 郑军 on 2017/9/26.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "DMBasePickView.h"
#define ZHToobarHeight 40
#define IS_IPHONE6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
@interface DMBasePickView()<UIPickerViewDelegate , UIPickerViewDataSource> {
    id _label ;
    NSMutableArray *_indexArray ;
    NSInteger _currentChoose ;
}
//plist文件名称
@property (nonatomic , copy) NSString *plistName ;
//数组元素类型
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;
@end

@implementation DMBasePickView

/**
 plistArray的get方法，，每次get的时候都会去刷新pickview
 @return pickview显示的数据
 */
-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    if (self.pickView) {
         [self.pickView reloadAllComponents];
    }
    return _plistArray;
}

/**
 返回数组（分组）元素的内容

 @return 分组元素
 */
-(NSArray *)componentArray{
    
    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}


/**
 pickview的初始化方法
 @param array 数组的内容
 @return 所需的视图，包含一个toolbar
 */
-(instancetype)initPickviewWithArray:(NSArray *)array{
    self=[super init];
    if (self) {
        _plistArray=array;
        _indexArray = [[NSMutableArray alloc] init];
        [self setArrayClass:array];
        _indexParam = [[NSMutableDictionary alloc] init];
        [self setUpPickView];
        [self getPickViewFrame];
    }
    return self;
}

/**
 数组元素的类型，，如果是字典类型，那么就加入到_dicKeyArray之中
 @param array 数组元素数据
 */
-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

/**
 初始化pickview
 */
-(void)setUpPickView{
    [self addSubview:self.toolbar] ;
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, [UIScreen mainScreen].bounds.size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight)] ;
        UIButton *leftItem = ({
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            leftBtn.frame = CGRectMake(30, 0, 60, 44);
            leftBtn.backgroundColor = [UIColor clearColor];
            [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
            [leftBtn setTitleColor:[UIColor colorWithRed:46/255.0 green:127/255.0 blue:247/255.0 alpha:1.0]  forState:UIControlStateNormal];
            [leftBtn addTarget:self
                        action:@selector(cancleTheOperation)
              forControlEvents:UIControlEventTouchUpInside] ;
            leftBtn ;
        }) ;
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem] ;
        UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIButton *rightItem = ({
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(30, 0, 60, 44);
            rightBtn.backgroundColor = [UIColor clearColor];
            [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor colorWithRed:46/255.0 green:127/255.0 blue:247/255.0 alpha:1.0]  forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(doneClickOperation) forControlEvents:UIControlEventTouchUpInside];
            rightBtn ;
        }) ;
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem] ;
        _toolbar.items = @[leftButtonItem , centerSpace , rightButtonItem] ;
        _toolbar.barStyle = UIBarStyleDefault ;
    }
    return _toolbar ;
}

/**
 点击取消的操作
 */
- (void)cancleTheOperation {
    [self removeThePickView] ;
}

/**
 点击完成的操作
 */
- (void)doneClickOperation {
    [self removeThePickView] ;
//    self.chooseIndex =
    if (self.confirmHandler) {
        self.confirmHandler(_resultString) ;
    }
}

- (void)removeThePickView {
    if (self.dismissCompared) {
        self.dismissCompared() ;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, _pickeviewHeight + ZHToobarHeight) ;
    }completion:^(BOOL finished) {
        [self removeFromSuperview] ;
    }] ;
}

/**
 设置自身的大小与位置
 */
-(void)getPickViewFrame{
    float height = _pickeviewHeight + ZHToobarHeight ;
    float currentY =[UIScreen mainScreen].bounds.size.height ;
    self.frame = CGRectMake(0, currentY, [UIScreen mainScreen].bounds.size.width, height) ;
}

/**
 显示pickview
 */
- (void)show{
    if ([[_plistArray objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        //如果数组中的元素还是数组
        if (_chooseIndex) {
            if (_plistArray.count != _chooseIndex.count) {
                return ;
            }else {
                for (int i = 0; i < _chooseIndex.count; i++) {
                    [self.pickView selectRow:[[_chooseIndex objectAtIndex:i] intValue] inComponent:i animated:YES];
                }
            }
            
        }else {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < _plistArray.count; i++) {
                [tempArr addObject:@"0"];
                [self.pickView selectRow:0 inComponent:i animated:YES];
            }
            _chooseIndex = tempArr ;
        }
    }else {
        if (_chooseIndex) {
            _currentChoose = [[_chooseIndex objectAtIndex:0] integerValue];
            [self.pickView selectRow:_currentChoose inComponent:0 animated:YES];
        }else {
            _chooseIndex = @[@"0"];
            [self.pickView selectRow:0 inComponent:0 animated:YES];
        }
        _resultString = [self.plistArray objectAtIndex:_currentChoose] ;
    }
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow ;
    [keyWindow addSubview:self] ;
    float height = _pickeviewHeight + ZHToobarHeight ;
    float currentY =[UIScreen mainScreen].bounds.size.height ;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, currentY - height, [UIScreen mainScreen].bounds.size.width, height) ;
    }] ;
}




#pragma mark - UIPickViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_isLevelDic&&component%2==0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        NSInteger cIndex = [pickerView selectedRowInComponent:0];
        NSLog(@"cIndex is %ld",(long)cIndex);
        _currentChoose = cIndex ;
        NSString *tempStr = [NSString stringWithFormat:@"%ld",(long)cIndex];
        if (_indexArray && _indexArray.count > 0) {
            [_indexArray replaceObjectAtIndex:0 withObject:tempStr];
            _chooseIndex = _indexArray ;
        }
    }else if (_isLevelArray){
        _resultString=@"";
        NSLog(@"%@",self.componentArray);
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                NSString *tempStr = [NSString stringWithFormat:@"%ld",(long)cIndex];
                [_indexParam setObject:@(cIndex) forKey:@(i)];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
                
                if (_indexArray&&_indexArray.count != 0) {
                    [_indexArray replaceObjectAtIndex:i withObject:tempStr];
                }
            }else{
                NSString *indexStr = [_chooseIndex objectAtIndex:i];
                int index = [indexStr intValue];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][index]];
            }
        }
        _chooseIndex = _indexArray ;
    }else if (_isLevelDic){
        if (component==0) {
            _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSLog(@"index is %ld",(long)[pickerView selectedRowInComponent:component]);
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter ;
    label.adjustsFontSizeToFitWidth = YES ;
    label.textColor = [UIColor blackColor];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    _label = label ;
    return label;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
            if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component = 1;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString){
        component=1;
    }else if(_isLevelDic){
        component=[_levelTwoDic allKeys].count*2;
    }
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    }else if (_isLevelString){
        rowArray=_plistArray;
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        for (id dicValue in [dic allValues]) {
            if ([dicValue isKindOfClass:[NSArray class]]) {
                if (component%2==1) {
                    rowArray=dicValue;
                }else{
                    rowArray=_plistArray;
                }
            }
        }
    }
    return rowArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger count = 0;
    if([[_plistArray objectAtIndex:0] isKindOfClass:[NSArray class]]) {
        count = _plistArray.count;
    }else {
        count = 1 ;
    }
    CGFloat width = pickerView.frame.size.width/count;
    return width;
}

-(void)setPickViewColer:(UIColor *)color {
    
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler {
    self = [super init] ;
    if (self) {
        
    }
    return self ;
}

//设置最大的日期
- (void)setDatePickerMaxDate:(NSDate *)date {
    
}

//设置最小日期
- (void)setDatePickerMinDate:(NSDate *)date {
    
}

/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color {
    
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color {
    
}

- (void)setTitleFont:(float)fontSize {
    
}

- (void)setChooseIndex:(NSArray *)chooseIndex {
    _chooseIndex = chooseIndex ;
    
    NSLog(@"%ld",(long)self.plistArray.count);
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    if (_plistArray && _plistArray.count != 0) {
        if ([[_plistArray objectAtIndex:0] isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < _plistArray.count; i++) {
                [tempArr addObject:@"0"] ;
            }
            
        }else {
            [tempArr addObject:@"0"] ;
        }
    }
    _indexArray = [[NSMutableArray alloc] initWithArray:_chooseIndex?_chooseIndex:tempArr];
}
@end
