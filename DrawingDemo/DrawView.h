//
//  DrawView.h
//  eCamera
//
//  Created by shiguang on 2018/8/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DrawModeSquare = 0,
    DrawModeLine = 1,
    DrawModeCircle = 2,
    DrawModeTriangle = 3,
    
}DrawMode;
typedef enum {
    DrawLineTypeDefault = 0,
    DrawLineType1 = 1,
    DrawLineType2 = 2,
    DrawLineType3 = 3,
}DrawLineType;

@interface DrawView : UIView

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIColor *drawColor;
//当前绘图模式
@property (nonatomic,assign) DrawMode drawMode;
@property (nonatomic,assign) DrawLineType drawLineType;
@property (nonatomic,assign) CGFloat sliderValue;
- (UIImage *)getImage;
- (void)deleteLastDrawing;

@end
