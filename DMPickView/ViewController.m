//
//  ViewController.m
//  DMPickView
//
//  Created by 郑军 on 2017/9/26.
//  Copyright © 2017年 郑军. All rights reserved.
//

#import "ViewController.h"
#import "DMPickView.h"
#import "Masonry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds] ;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view) ;
    }] ;

    DMPickView *pickView = [[DMPickView alloc] initWithFrame:CGRectMake(0, 300, 200, 40)] ;
    pickView.pickArray = @[@[@"1",@"2",@"3"],@[@"最近",@"在做",@"什么"]] ;
    pickView.backgroundColor = [UIColor redColor] ;
    pickView.title = @"3什么" ;
    [scrollView addSubview:pickView] ;
    
    DMPickView *pickViewsecond = [[DMPickView alloc] initWithFrame:CGRectMake(0, 600, 200, 40)] ;
    pickViewsecond.pickArray = @[@"你是",@"在哪",@"上班"] ;
    pickViewsecond.title = @"2" ;
    pickViewsecond.backgroundColor = [UIColor redColor] ;
    [scrollView addSubview:pickViewsecond] ;
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pickViewsecond) ;
    }] ;
    
    DMPickView *pickViewthird = [[DMPickView alloc] initWithFrame:CGRectMake(0, 1000, 200, 40)] ;
    pickViewthird.pickArray = @[@"你是",@"在哪",@"上班"] ;
    pickViewthird.title = @"2" ;
    pickViewthird.backgroundColor = [UIColor redColor] ;
    [scrollView addSubview:pickViewthird] ;
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(pickViewthird) ;
    }] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
