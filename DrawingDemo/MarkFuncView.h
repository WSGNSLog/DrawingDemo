//
//  MarkFuncView.h
//  eCamera
//
//  Created by shiguang on 2018/8/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LineShapeSquare = 0,
    LineShapeLine = 1,
    LineShapeCircle = 2,
    LineShapeTriangle = 3,
    
}LineShape;
typedef enum {
    LineTypeDefault = 0,
    LineType1 = 1,
    LineType2 = 2,
    LineType3 = 3,
}LineType;


@protocol MarkFuncViewDelegate <NSObject>

@optional
- (void)lineShapeDidChange:(LineShape)newShape;
- (void)dashLineTypeDidChange:(LineType)newType;
- (void)lineThicknessDidChange:(NSInteger)newValue;
- (void)lineColorDidChange:(UIColor *)newColor;

@end


@interface MarkFuncView : UIScrollView

@property (nonatomic,weak) id<MarkFuncViewDelegate>markDelegate;


@end

@interface LineModeView : UIView

@property (nonatomic,assign) LineShape lineShape;
@property (nonatomic,copy) void(^ShapeChangeBlock)(LineShape shape);

- (instancetype)initWithFrame:(CGRect)frame DefaultShape:(LineShape)shape;

@end

@interface DashLineView : UIView

@property (nonatomic,copy) void(^LineTypeChangeBlock)(LineType type);
@property (nonatomic,assign) LineType lineType;
- (instancetype)initWithFrame:(CGRect)frame DefaultType:(LineType)type;

@end

@interface LineColorView : UIView

@property (nonatomic,copy) void(^DrawColorBlock)(UIColor *color);

@end

@interface LineThicnessView : UIView
@property (nonatomic,copy) void(^SliderChangeBlock)(CGFloat sliderValue);


@end

