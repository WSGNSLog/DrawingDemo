//
//  MarkFuncView.m
//  eCamera
//
//  Created by shiguang on 2018/8/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "MarkFuncView.h"
#import "PhotoBeautyParam.h"

#define EdgeMargin 20
#define btnWH 30

@interface MarkFuncView ()

@end

@implementation MarkFuncView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    
    WEAKSELF
    LineModeView *lineShapeView = [[LineModeView alloc]initWithFrame:self.bounds DefaultShape:LineShapeSquare];
    lineShapeView.ShapeChangeBlock = ^(LineShape shape) {
        if (weakSelf.markDelegate && [weakSelf.markDelegate respondsToSelector:@selector(lineShapeDidChange:)]) {
            [weakSelf.markDelegate lineShapeDidChange:shape];
        }
    };
    [self addSubview:lineShapeView];
    
    DashLineView *dashLineView = [[DashLineView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height) DefaultType:LineTypeDefault];
    dashLineView.LineTypeChangeBlock = ^(LineType type) {
        if (weakSelf.markDelegate && [weakSelf.markDelegate respondsToSelector:@selector(dashLineTypeDidChange:)]) {
            [weakSelf.markDelegate dashLineTypeDidChange:type];
        }
    };
    [self addSubview:dashLineView];
    
    LineColorView *colorView = [[LineColorView alloc]initWithFrame:CGRectMake(self.width*2, 0, self.width, self.height)];
    colorView.DrawColorBlock = ^(UIColor *color) {
        if (weakSelf.markDelegate && [weakSelf.markDelegate respondsToSelector:@selector(lineColorDidChange:)]) {
            [weakSelf.markDelegate lineColorDidChange:color];
        }
    };
    [self addSubview:colorView];
    
    LineThicnessView *thicknessView = [[LineThicnessView alloc]initWithFrame:CGRectMake(self.width *3, 0, self.width, self.height)];
    thicknessView.SliderChangeBlock = ^(CGFloat sliderValue) {
        if (weakSelf.markDelegate && [weakSelf.markDelegate respondsToSelector:@selector(lineThicknessDidChange:)]) {
            [weakSelf.markDelegate lineThicknessDidChange:sliderValue];
        }
    };
    [self addSubview:thicknessView];
}

@end

@interface LineModeView ()

@end

@implementation LineModeView

- (instancetype)initWithFrame:(CGRect)frame DefaultShape:(LineShape)shape{
    if (self = [super initWithFrame:frame]) {
        self.lineShape = shape;
        [self createShapeOption];
        self.backgroundColor = FuncViewBGColor
    }
    
    return self;
}
- (void)createShapeOption{
    
    NSArray *imgArr = @[@"lineShape_square",@"lineShape_line",@"lineShape_circle",@"lineShape_triangle"];
  
    UILabel *label = [[UILabel alloc]init];
    label.text = @"样式";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, (self.height-15)/2, 30, 15);
    [self addSubview:label];
    for (int i=0; i<imgArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(label.x+label.width+EdgeMargin*(i+1)+btnWH*i, (self.height-btnWH)/2.0, btnWH, btnWH);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highLight",imgArr[i]]] forState:UIControlStateSelected];
        btn.selected = (i==self.lineShape? YES:NO);
        [btn addTarget:self action:@selector(shapeChangeClick:) forControlEvents:UIControlEventTouchUpInside];
     
        [self addSubview:btn];
    }
    
}
- (void)shapeChangeClick:(UIButton *)btn{
    btn.selected = YES;
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subV;
            if (subBtn.tag != btn.tag) {
                subBtn.selected = NO;
            }
        }
    }
    if (self.ShapeChangeBlock) {
        self.ShapeChangeBlock((int)btn.tag);
    }
}
@end


@interface DashLineView ()

@end

@implementation DashLineView
- (instancetype)initWithFrame:(CGRect)frame DefaultType:(LineType)type{
    if (self = [super initWithFrame:frame]) {
        self.lineType = LineTypeDefault;
        [self createDashedTypeOption];
        self.backgroundColor = FuncViewBGColor
    }
    
    return self;
}
- (void)createDashedTypeOption{
    
    NSArray *imgArr = @[@"lineShape_line",@"icon_dashLineOne",@"icon_dashLineTwo",@"icon_dashLineThree"];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"线型";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, (self.height-15)/2, 30, 15);
    [self addSubview:label];

    for (int i=0; i<imgArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = CGRectMake(label.x+label.width+EdgeMargin*(i+1)+btnWH*i, (self.height-btnWH)/2.0, btnWH, btnWH);
        [btn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highLight",imgArr[i]]] forState:UIControlStateSelected];
        btn.selected = (i==self.lineType? YES:NO);
        [btn addTarget:self action:@selector(lineTypeChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
- (void)lineTypeChange:(UIButton *)btn{
    btn.selected = YES;
    for (UIView *subV in self.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subV;
            if (subBtn.tag != btn.tag) {
                subBtn.selected = NO;
            }
        }
    }
    if (self.LineTypeChangeBlock) {
        self.LineTypeChangeBlock((int)btn.tag);
    }
}

@end

@interface LineColorView ()

@end

@implementation LineColorView{
    UIButton *selectedBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createColorBord];
        self.backgroundColor = FuncViewBGColor
    }
    
    return self;
}

-(void)createColorBord{
    
    
    //创建每个色块
    NSArray *colors = @[@"ffffff",@"7d7d7d",@"000000",@"810000",@"cc0000",@"ff0000",@"ff7200",@"ffbf00",@"6cbf00",@"80d4ff",@"0080ff"];
    CGFloat leftMargin = 15;
    CGFloat rightMargin = 5;
    CGFloat btnW = (self.width-leftMargin-rightMargin)/colors.count;
    for (int i =0; i<colors.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(leftMargin+btnW*i, (self.height-15)/2, btnW, 15)];
        [self addSubview:btn];
        [btn setBackgroundColor:[UIColor colorWithHexString:colors[i]]];
        [btn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            selectedBtn = [[UIButton alloc]init];
            selectedBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
            selectedBtn.layer.cornerRadius = 5;
            selectedBtn.layer.borderColor = [UIColor colorWithRed:0.36f green:0.72f blue:0.76f alpha:1.0f].CGColor;
            selectedBtn.layer.borderWidth = 1.5;
            [self addSubview:selectedBtn];
            [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn).offset = 5;
                make.top.left.equalTo(btn).offset = -3;
            }];
        }
    }
    [self bringSubviewToFront:selectedBtn];
}
//切换颜色
-(void)changeColor:(id)target{
    UIButton *btn = (UIButton *)target;
    
    if (self.DrawColorBlock) {
        self.DrawColorBlock([btn backgroundColor]);
    }
    [selectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(btn).offset = 3;
        make.top.left.equalTo(btn).offset = -3;
    }];
    
}


@end

@interface LineThicnessView ()

@end

@implementation LineThicnessView

{
    //当前笔触粗细选择器
    UISlider *slider;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = FuncViewBGColor
        [self createStrokeWidthSlider];
    }
    
    return self;
}

//创建笔触粗细选择器
-(void)createStrokeWidthSlider{
    
    CGFloat leftMargin = 20;
    CGFloat rightMargin = 10;
    CGFloat sliderY = (self.height-20)/2;
    CGFloat sliderW = self.width - leftMargin - rightMargin;
    CGFloat sliderH = 20;
    
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(leftMargin, sliderY, sliderW, sliderH)];
    [slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
    slider.maximumValue = 10;
    slider.minimumValue = 1;
    slider.value = 5;
    slider.minimumTrackTintColor = [UIColor colorWithRed:37/255.0 green:185/255.0 blue:195/255.0 alpha:1.0];
    slider.maximumTrackTintColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    slider.transform = CGAffineTransformMakeScale(1.0, 2.0);
    [slider setThumbImage:[UIImage imageNamed:@"sliderThumbImage"] forState:UIControlStateNormal];
    if (self.SliderChangeBlock) {
        self.SliderChangeBlock(1);
    }
    [self addSubview:slider];
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, sliderY - 15, 20, 15)];
    leftLabel.text = @"细";
    leftLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(slider.frame)-20, sliderY - 15, 20, 15)];
    rightLabel.text = @"粗";
    rightLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:rightLabel];
}
- (void)sliderValueChange{
    if (self.SliderChangeBlock) {
        self.SliderChangeBlock(slider.value);
    }
}

@end
