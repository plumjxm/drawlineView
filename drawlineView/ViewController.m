//
//  ViewController.m
//  drawlineView
//
//  Created by plum on 17/9/13.
//  Copyright © 2017年 plum. All rights reserved.
//

#import "ViewController.h"
#import "MPDrawLineView.h"
#import "MPDateWalkModel.h"

static CGFloat footL  =  15;

@interface ViewController ()
@property (nonatomic,strong) MPDrawLineView *footView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.footView];
    
    NSArray *stepsArr = @[@7800,@3098,@2500,@10990,@2389,@6538,@7890];
    NSArray *dateArr = @[@"9月7",@"8",@"9",@"10",@"11",@"12",@"13"];

    NSMutableArray *newArr = [NSMutableArray new];
    for (int i = 0; i < 7; i++) {
        MPDateWalkModel *model = [[MPDateWalkModel alloc]init];
        model.steps = [stepsArr[i] floatValue];
        model.date = dateArr[i];
        [newArr addObject:model];
    }
    [_footView layerDataArr:newArr];

}



- (MPDrawLineView *)footView
{
    if (_footView == nil) {
        _footView = [[MPDrawLineView alloc]initWithFrame:CGRectMake(footL, 80, self.view.frame.size.width-footL*2, 250)];
    }
    return _footView;
}


@end
