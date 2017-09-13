//
//  MPDrawLineView.m
//  tenMS
//
//  Created by plum on 17/7/6.
//  Copyright © 2017年 plum. All rights reserved.
//

#import "MPDrawLineView.h"
#import "MPDateWalkModel.h"
#import "UIViewExt.h"

static CGFloat footH  = 35;
static CGFloat topH  = 58;
static CGFloat centerH  =  130;
static CGFloat lineLeft  =  15;

static NSInteger maxnum  =  25000;

static CGFloat LINEH  =  0.5;

@interface MPDrawLineView ()
@property (nonatomic, strong) CAShapeLayer *lineChartLayer;
/** 渐变背景视图 */
@property (nonatomic, strong) UIView *gradientBackgroundView;

@property (nonatomic, strong) UIView *lineBackgroundView;

/** 渐变图层 */
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
/** 颜色数组 */
@property (nonatomic, strong) NSMutableArray *gradientLayerColors;

@property (nonatomic, weak) UILabel *currentLabel;


@property(strong,nonatomic)NSArray *dateArr;

@property (nonatomic, weak) UILabel *selectLabel;


@end

@implementation MPDrawLineView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        frame.size.height = topH+centerH+footH;
        self.frame = frame;
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        [self initView];
        
        
    }
    return self;
}
- (void)layerDataArr:(NSArray *)arr
{
    
    
        self.dateArr = arr;

        [self dravLine];
        
        for (NSInteger i = 0; i < self.dateArr.count; i++) {
            MPDateWalkModel *model = self.dateArr[i];
            NSString *daystr = model.date;
           
            UILabel * LabelMonth = [self viewWithTag:i+1000];
            LabelMonth.text = daystr;
            
            if (i==6) {
                _currentLabel.text = [NSString stringWithFormat:@"%.0f",model.steps];
            }
            
            
        }

}
#pragma mark - Private
- (void)initView
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self drawGradientBackgroundView];
    
    [self initTopView];

    
    self.lineBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(lineLeft, topH, self.frame.size.width-lineLeft*2, centerH)];
    [self.gradientBackgroundView addSubview:self.lineBackgroundView];
    //_lineBackgroundView.backgroundColor = [UIColor whiteColor];
   
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(0, (centerH-LINEH)/2, _lineBackgroundView.frame.size.width, LINEH);
    titleImgView.backgroundColor = [UIColor whiteColor];
    titleImgView.alpha = 0.15;
    [self.lineBackgroundView addSubview:titleImgView];
    titleImgView.center = CGPointMake(centerH/3, centerH*2/3);
    CGRect frame = titleImgView.frame;
    frame.origin.x = 0;
    titleImgView.frame = frame;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = @"1w";
    contentLabel.font = [UIFont systemFontOfSize:10];
    contentLabel.textColor = [UIColor whiteColor];
    [self addSubview:contentLabel];
    [contentLabel sizeToFit];
    contentLabel.center = CGPointMake(centerH/3,topH+centerH*2/3);
    
    contentLabel.left = 0;

    contentLabel.right = self.width;

    [self createLabelX];
    [self createLabelY];
    
//    [self dravLine];
    
    UIImageView *linelabel = [[UIImageView alloc]init];
    linelabel.frame = CGRectMake(lineLeft,  _lineBackgroundView.bottom, _lineBackgroundView.width+10, LINEH);
    linelabel.backgroundColor = [UIColor whiteColor];
    linelabel.alpha = 0.3;
    [self addSubview:linelabel];
        
    
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.font = [UIFont systemFontOfSize:10];
    selectLabel.textColor = [UIColor whiteColor];
    [self.lineBackgroundView addSubview:selectLabel];
    self.selectLabel = selectLabel;

}
- (void)initTopView
{
    CGFloat height = 42;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(lineLeft, 0, self.width-lineLeft*2, topH)];
    //topView.backgroundColor = [UIColor blueColor];
    [self.gradientBackgroundView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, height)];
    titleLabel.text = @"步数";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    [topView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textAlignment = NSTextAlignmentRight;
    contentLabel.frame = CGRectMake(topView.width-200, 0, 200, height);
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.textColor = [UIColor whiteColor];
    [topView addSubview:contentLabel];
    _currentLabel = contentLabel;
    
    
    UIImageView *titleImgView = [[UIImageView alloc]init];
    titleImgView.frame = CGRectMake(0, contentLabel.bottom, topView.width, LINEH);
    titleImgView.backgroundColor = [UIColor whiteColor];
    titleImgView.alpha = 0.4;
    [topView addSubview:titleImgView];

}
#pragma mark 创建x轴的数据
- (void)createLabelX{
    CGFloat width = self.lineBackgroundView.width;
    CGFloat height = self.height;
    CGFloat labelW = width/6;
    for (NSInteger i = 0; i < 7; i++) {
       
        UILabel * LabelMonth = [[UILabel alloc]initWithFrame:CGRectMake(lineLeft+ labelW * i, height - footH, labelW, footH)];
        LabelMonth.tag = 1000+i;
        //LabelMonth.text = [NSString stringWithFormat:@"%ld",i+1];
        LabelMonth.font = [UIFont systemFontOfSize:10];
        LabelMonth.textColor = [UIColor whiteColor];
        [self addSubview:LabelMonth];
    }
    
   
    
}
#pragma mark 创建y轴数据
- (void)createLabelY{
    CGFloat Ydivision = 2;
    for (NSInteger i = 0; i < Ydivision; i++) {
        UILabel * labelYdivision = [[UILabel alloc]initWithFrame:CGRectMake(0, self.lineBackgroundView.height/Ydivision *i, 0, 0)];
        //labelYdivision.backgroundColor = [UIColor greenColor];
        labelYdivision.tag = 2000 + i;
        //labelYdivision.text = [NSString stringWithFormat:@"%.0f",(Ydivision - i)];
        //labelYdivision.font = [UIFont systemFontOfSize:10];
        [self.lineBackgroundView addSubview:labelYdivision];
    }
}
#pragma mark -
//- (void)drawRect:(CGRect)rect{
//    /*******画出坐标轴********/
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
//    CGContextMoveToPoint(context, _bounceX, _bounceY);
//    CGContextAddLineToPoint(context, _bounceX, rect.size.height - _bounceY);
//    CGContextAddLineToPoint(context,rect.size.width -  _bounceX, rect.size.height - _bounceY);
//    CGContextStrokePath(context);
//    
//}
- (void)drawGradientBackgroundView {
    // 渐变背景视图（不包含坐标轴）
    self.gradientBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:self.gradientBackgroundView];
    /** 创建并设置渐变背景图层 */
    //初始化CAGradientlayer对象，使它的大小为渐变背景视图的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.gradientBackgroundView.bounds;
    //设置渐变区域的起始和终止位置（范围为0-1），即渐变路径
    self.gradientLayer.startPoint = CGPointMake(0, 0.0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 0.0);
    //设置颜色的渐变过程
    self.gradientLayerColors = [NSMutableArray arrayWithArray:@[(__bridge id)[UIColor colorWithRed:253 / 255.0 green:164 / 255.0 blue:8 / 255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:251 / 255.0 green:37 / 255.0 blue:45 / 255.0 alpha:1.0].CGColor]];
    self.gradientLayer.colors = self.gradientLayerColors;
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.gradientBackgroundView.layer addSublayer:self.gradientLayer];
    //[self.layer addSublayer:self.gradientLayer];
}
#pragma mark 画折线图
- (void)dravLine{
    
    CGFloat falglabelW = 4;

    MPDateWalkModel *model1 = self.dateArr[0];
    
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    CGFloat x = 0;
    CGFloat steps = MIN(model1.steps, maxnum);
    CGFloat y = (maxnum -steps) /maxnum * centerH;
    [path moveToPoint:CGPointMake(x, y)];
    
    
    CGFloat bgsep = 0.5;
    UIBezierPath * bgpath = [[UIBezierPath alloc]init];
    bgpath.lineWidth = 0.0;
    [bgpath moveToPoint:CGPointMake(x-bgsep, y)];

    
    UILabel * falglabel = [[UILabel alloc]initWithFrame:CGRectMake(x - falglabelW/2 , y -  falglabelW/2 , falglabelW, falglabelW)];
    falglabel.layer.masksToBounds = YES;
    falglabel.layer.cornerRadius = falglabelW/2;
    falglabel.backgroundColor = [UIColor whiteColor];
    [self.lineBackgroundView addSubview:falglabel];
    
    CGFloat circleBtnW = 30;
    UIButton *arrowButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton1.frame = CGRectMake(0, 0, circleBtnW, circleBtnW);
    arrowButton1.tag = 5000;
    [arrowButton1 addTarget:self action:@selector(circleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.lineBackgroundView addSubview:arrowButton1];
    arrowButton1.center = falglabel.center;
    
    
    CGFloat width = self.lineBackgroundView.width;
    CGFloat labelW = width/(7-1);
    
    //创建折现点标记
    for (NSInteger i = 1; i< 7; i++) {
        
        MPDateWalkModel *model = self.dateArr[i];

         x = labelW*i;
        CGFloat steps = MIN(model.steps, maxnum);
         y = (maxnum -steps) /maxnum * centerH;
        [path addLineToPoint:CGPointMake(x,  y)];
        if (i==6) {
            [bgpath addLineToPoint:CGPointMake(x+bgsep,  y)];
        }else{
            [bgpath addLineToPoint:CGPointMake(x,  y)];
        }
        UILabel * falglabel1 = [[UILabel alloc]initWithFrame:CGRectMake(x - falglabelW/2 , y -  falglabelW/2 , falglabelW, falglabelW)];
        falglabel1.layer.masksToBounds = YES;
        falglabel1.layer.cornerRadius = falglabelW/2;
        falglabel1.backgroundColor = [UIColor whiteColor];
        [self.lineBackgroundView addSubview:falglabel1];
        
        
        UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        arrowButton.frame = CGRectMake(0, 0, circleBtnW, circleBtnW);
        arrowButton.tag = 5000+i;
        //arrowButton.backgroundColor = [UIColor blueColor];
        [arrowButton addTarget:self action:@selector(circleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.lineBackgroundView addSubview:arrowButton];
        arrowButton.center = falglabel1.center;
    }


     //[path stroke];
    
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = path.CGPath;
    self.lineChartLayer.strokeColor = [UIColor whiteColor].CGColor;
//    self.lineChartLayer.fillColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];

    // 默认设置路径宽度为0，使其在起始状态下不显示
    self.lineChartLayer.lineWidth = 1;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    //self.lineChartLayer.strokeEnd = 0;

    [self.lineBackgroundView.layer addSublayer:self.lineChartLayer];//直接添加导视图上
    //   self.gradientBackgroundView.layer.mask = self.lineChartLayer;//添加到渐变图层
    [bgpath addLineToPoint:CGPointMake(_lineBackgroundView.width+bgsep,  centerH)];
    [bgpath addLineToPoint:CGPointMake(0-bgsep,  centerH)];
    CAShapeLayer *bglayer = [CAShapeLayer layer];
    bglayer.path = bgpath.CGPath;
    bglayer.strokeColor = [UIColor clearColor].CGColor;
    bglayer.fillColor = [[UIColor colorWithWhite:1 alpha:0.2] CGColor];
    [self.lineBackgroundView.layer addSublayer:bglayer];

    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
    //pathAnimation.delegate = self;
    [self.lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    //[self.lineChartLayer addAnimation:pathAnimation forKey:@"drawCircleAnimation"];

}
#pragma mark - 
- (void)circleButtonDidClick:(UIButton *)sender
{
    NSInteger tag = sender.tag-5000;
    MPDateWalkModel *model = self.dateArr[tag];
    _selectLabel.text = [NSString stringWithFormat:@"%.0f",model.steps];
    [_selectLabel sizeToFit];
    _selectLabel.center = sender.center;
    _selectLabel.bottom = 0;

}
@end
