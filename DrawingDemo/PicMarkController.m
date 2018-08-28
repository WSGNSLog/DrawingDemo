//
//  PicMarkController.m
//  eCamera
//
//  Created by shiguang on 2018/8/23.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "PicMarkController.h"
#import "MarkFuncView.h"
#import "PhotoBeautyParam.h"
#import "DrawView.h"
#import <AVFoundation/AVFoundation.h>

#define WWidth [UIScreen mainScreen].bounds.size.width
#define WHeight [UIScreen mainScreen].bounds.size.height
#define scrollW WWidth - 20*2 -30 -1
@interface PicMarkController ()<MarkFuncViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *lineModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dashLineBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineColorBtn;
@property (weak, nonatomic) IBOutlet UIButton *lineThicknessBtn;
@property (weak, nonatomic) IBOutlet UIView *funcView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) MarkFuncView *scrollView;
@property (strong,nonatomic) UIImage *originImg;
@property (weak, nonatomic) UIView *imgBgView;
@property (weak, nonatomic) DrawView *drawView;
@property (retain,nonatomic) UIImageView *imageView;
@property (nonatomic, readonly) CGRect imageRect;
//@property (nonatomic,assign) LineShape lineShape;
@end

@implementation PicMarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.originImg = [UIImage imageNamed:@"1.jpg"];
    self.funcView.backgroundColor = FuncViewBGColor
    MarkFuncView *scrollView = [[MarkFuncView alloc]initWithFrame:CGRectMake(0, 0, scrollW, FuncViewH)];
    scrollView.contentSize = CGSizeMake(scrollW * 4, FuncViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = FuncViewBGColor;
    scrollView.markDelegate = self;
    [self.funcView addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.imgBgView.frame = CGRectMake(0, 0, WWidth, WHeight-FuncViewH-50);
    self.imageView =  [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.originImg;
    self.imageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];;
    [self.imgBgView addSubview:self.imageView];
    self.imageView.frame = self.imgBgView.bounds;
    self.drawView.frame = CGRectMake(self.imageRect.origin.x, self.imageRect.origin.y, self.imageRect.size.width, self.imageRect.size.height);
}

- (IBAction)barBtnClick:(UIButton *)btn {
    btn.selected = YES;
    for (UIView *subV in self.bottomBarView.subviews) {
        if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subV;
            if (subBtn.tag != btn.tag) {
                subBtn.selected = NO;
            }
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*btn.tag, 0) animated:NO];
}
- (IBAction)deleteLastClick:(UIButton *)sender {
    [self.drawView deleteLastDrawing];
}

- (IBAction)closeClick:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveClick:(UIButton *)sender {
    if (self.ImageBlock) {
        self.ImageBlock([self.drawView getImage]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)lineShapeDidChange:(LineShape)newShape{
    self.drawView.drawMode = (int)newShape;
}
- (void)dashLineTypeDidChange:(LineType)newType{
    self.drawView.drawLineType = (int)newType;
}
- (void)lineThicknessDidChange:(NSInteger)newValue{
    self.drawView.sliderValue = newValue;
}
- (void)lineColorDidChange:(UIColor *)newColor{
    
    self.drawView.drawColor = newColor;
}

- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.originImg.size, self.imgBgView.bounds);
}
- (UIView *)imgBgView{
    if (!_imgBgView) {
        UIView *imgBgView = [[UIView alloc]init];
        [self.view addSubview:imgBgView];
        _imgBgView = imgBgView;
    }
    return _imgBgView;
}
- (DrawView *)drawView{
    if (!_drawView) {
        DrawView *drawView = [[DrawView alloc]init];
        self.drawView = drawView;
        self.drawView.image = self.originImg;
        self.drawView.drawMode = DrawModeSquare;
        self.drawView.drawColor = [UIColor colorWithHexString:@"ffffff"];
        [self.imgBgView addSubview:drawView];
    }
    return _drawView;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
