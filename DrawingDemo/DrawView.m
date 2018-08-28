//
//  DrawView.m
//  eCamera
//
//  Created by shiguang on 2018/8/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import "DrawView.h"
#import "BezierStep.h"
#import <math.h>

@interface DrawView()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation DrawView{
    
    //画的线路径的集合，内部是NSMutableArray类型
    NSMutableArray *paintSteps;
    //当前选中的颜色
    UIColor *currColor;
    //画的线路径的集合
    NSMutableArray *bezierSteps;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self paintViewInit];
    }
    return  self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return  self;
}
- (void)setDrawColor:(UIColor *)drawColor{
    currColor = drawColor;
    _drawColor = drawColor;
}

//初始化paintViewInit样式和数据
-(void)paintViewInit{
    //添加背景色
    self.backgroundColor = [UIColor clearColor];
    //初始化路径集合
    paintSteps = [[NSMutableArray alloc]init];
    bezierSteps = [[NSMutableArray alloc]init];
    self.sliderValue = 1;
}


- (CGRect)calRect:(BezierStep *)step{
    
    CGRect rect = CGRectZero;
    double w = roundf(fabs(step->endPoint.x - step->startPoint.x));
    double h = roundf(fabs(step->endPoint.y - step->startPoint.y));
    if (step->startPoint.x <=step->endPoint.x && step->startPoint.y <= step->endPoint.y) {
        rect = CGRectMake(roundf(step->startPoint.x), roundf(step->startPoint.y), w, h);
    }else if (step->startPoint.x < step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
        rect = CGRectMake(roundf(step->startPoint.x), roundf(step->endPoint.y), w, h);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
        rect = CGRectMake(roundf(step->endPoint.x), roundf(step->endPoint.y), w, h);
    }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y < step->endPoint.y ){
        rect = CGRectMake(roundf(step->endPoint.x), roundf(step->startPoint.y), w, h);
    }
    return rect;
}
- (CGPoint)calPoint1:(BezierStep *)step{
    CGFloat newX = 0;
    CGFloat newY = 0;
    
    CGFloat length = hypot(step->endPoint.x-step->startPoint.x, step->endPoint.y-step->startPoint.y);
    
    double angle = atan((step->endPoint.y - step->startPoint.y) / (step->endPoint.x - step->startPoint.x));
    if (angle == 0) {
        NSLog(@"error");
    }
    if (!isnan(angle)) {
        if (step->startPoint.x <=step->endPoint.x && step->startPoint.y <= step->endPoint.y) {
            newX = cos(angle + M_PI / 3 ) * length + step->startPoint.x;
            newY = sin(angle + M_PI / 3 ) * length + step->startPoint.y;
        }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
            newX = step->startPoint.x - cos(angle + M_PI / 3 ) * length;
            newY = step->startPoint.y - sin(angle + M_PI / 3 ) * length;
        }else if (step->startPoint.x < step->endPoint.x  && step->startPoint.y > step->endPoint.y ){
            newX = cos(angle + M_PI / 3 ) * length + step->startPoint.x;
            newY = step->startPoint.y - sin(angle + M_PI / 3 ) * length ;
        }else if (step->startPoint.x > step->endPoint.x  && step->startPoint.y < step->endPoint.y ){
            newX = step->startPoint.x - cos(angle + M_PI / 3 ) * length;
            newY = sin(angle + M_PI / 3 ) * length + step->startPoint.y;
        }
    }
    return CGPointMake(newX, newY);
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获取ctx
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //渲染bezier路径
    for (int i=0; i<bezierSteps.count; i++) {
        BezierStep *step = bezierSteps[i];
        
       
        //设置path 样式
        if (!step.color) {
            NSLog(@"error");
        }
        CGContextSetStrokeColorWithColor(ctx, [step.color CGColor]);
        CGContextSetLineWidth(ctx, step->strokeWidth);
      
        if (step.paintMode == PaintModeCircle) {
            CGPoint centerPoint = CGPointMake((step->startPoint.x+step->endPoint.x)/2, (step->startPoint.y+step->endPoint.y)/2);
            double a1 = centerPoint.x - step->startPoint.x;
            double a2 = centerPoint.y - step->startPoint.y;
            double radius = hypot(a1, a2);
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
            path.lineWidth = step->strokeWidth;
            
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            
            
            [path stroke];
        }
        if (step.paintMode == PaintModeTriangle) {
            
            CGPoint c = [self calPoint1:step];;
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            path.lineWidth = step->strokeWidth;
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            [path moveToPoint:step->startPoint];
            [path addLineToPoint:step->endPoint];
            [path moveToPoint:step->endPoint];
            [path addLineToPoint:c];
            [path moveToPoint:c];
            [path addLineToPoint:step->startPoint];
            [path closePath];///[path closePath]
            [path stroke];
        }
        
        if (step.paintMode == PaintModeSquare) {
           
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:[self calRect:step]];
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            path.lineWidth = step->strokeWidth;
            [path stroke];
            
        }
        
        if (step.paintMode == PaintModeLine) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            if (step.paintLineType == PaintLineType1) {
                CGFloat dashLineConfig[] = {4.0,2.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }else if (step.paintLineType == PaintLineType2){
                CGFloat dashLineConfig[] = {4.0, 2.0, 8.0, 2.0,16.0,2.0};
                [path setLineDash:dashLineConfig count:6 phase:0];
            }else if (step.paintLineType == PaintLineType3){
                CGFloat dashLineConfig[] = {1.0,1.0};
                [path setLineDash:dashLineConfig count:2 phase:0];
            }
            path.lineWidth = step->strokeWidth;
            [path moveToPoint:step->startPoint];
            [path addLineToPoint:step->endPoint];
            
            [path stroke];
        }
        
    }
    
    
}

#pragma mark -手指移动
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.drawMode) {
   
        //模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
            [self bezierModeTouchesBegan:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (self.drawMode) {
      
        //模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
            [self bezierModeTouchesMoved:touches withEvent:event];
            break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (self.drawMode) {

        //模式
        case DrawModeCircle:
        case DrawModeTriangle:
        case DrawModeLine:
        case DrawModeSquare:
            [self bezierModeTouchesEnded:touches withEvent:event];
            break;
        default:
            break;
    }
    
}

-(void)bezierModeTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //创建贝塞尔 步骤
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    
    if (step) {
        switch (step->status) {
                
            case BezierStepStatusSetStart:
            case BezierStepStatusSetEnd:
            {
                step =  [[BezierStep alloc]init];
                step.paintMode = (int)self.drawMode;
                step.paintLineType = (int)self.drawLineType;
                if (!currColor || !currColor.CGColor) {
                    NSLog(@"error");
                }
                step.color = currColor;
                step->strokeWidth = self.sliderValue;
                step->startPoint  = point;
                step->status = BezierStepStatusSetControl;
                [bezierSteps addObject:step];
            }
                break;
                
            default:
                break;
        }
        
    }else{
        step =  [[BezierStep alloc]init];
        step.paintMode = (int)self.drawMode;
        step.paintLineType = (int)self.drawLineType;
        if (!currColor ||!currColor.CGColor) {
            NSLog(@"error");
        }
        step.color = currColor;
        step->strokeWidth = self.sliderValue;
        step->startPoint  = point;
        step->status = BezierStepStatusSetControl;
        [bezierSteps addObject:step];
    }
    
    
}

-(void)bezierModeTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    step->status = BezierStepStatusSetControl;
    switch (step->status) {
            
        case BezierStepStatusSetStart:
        case BezierStepStatusSetControl:
        {
            step->controlPoint = point;
            step->endPoint = point;
        }
            
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
    
}

-(void)bezierModeTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    BezierStep *step = [bezierSteps lastObject];
    CGPoint point =[[touches anyObject]locationInView:self];
    switch (step->status) {
        case BezierStepStatusSetStart:
        case BezierStepStatusSetControl:
        {
            step->endPoint = point;
            step->status = BezierStepStatusSetEnd;
            
            if (point.x == step->startPoint.x && point.y==step->endPoint.y) {
                [bezierSteps removeLastObject];
            }
            
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
    
    
}


- (UIImage *)getImage{
    
    CGFloat w = self.image.size.width;
    CGFloat h = self.image.size.height;
    //以大图大小为底图
    //以showImg的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    //UIGraphicsBeginImageContextWithOptions(self.image.size, NO, 0);
    //先把大图 绘制到上下文中
    [self.image drawInRect:CGRectMake(0, 0, w, h)];
    //再把小图放到上下文中
    //[self.locationLabel drawInRect:CGRectMake(100, 100, 100, 50)];
    [self drawViewHierarchyInRect:CGRectMake(0,0, w, h) afterScreenUpdates:YES];
    
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    
    //CGImageRelease(imgRef);//imageView.image不需要释放
    
    return resultImg;
}
- (void)deleteLastDrawing{
    [bezierSteps removeLastObject];
    [self setNeedsDisplay];
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
