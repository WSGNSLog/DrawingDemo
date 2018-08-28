//
//  BezierStep.h
//  eCamera
//
//  Created by shiguang on 2018/8/24.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    BezierStepStatusSetStart,
    BezierStepStatusSetEnd,
    BezierStepStatusSetControl
}BezierStepStatus;

typedef enum {
    PaintModeSquare = 0,
    PaintModeLine = 1,
    PaintModeCircle = 2,
    PaintModeTriangle = 3,
}PaintMode;

typedef enum {
    PaintLineTypeDefault = 0,
    PaintLineType1 = 1,
    PaintLineType2 = 2,
    PaintLineType3 = 3,
}PaintLineType;

@interface BezierStep : NSObject{
    
@public
    
    //路径
    CGPoint startPoint;
    CGPoint controlPoint;
    CGPoint endPoint;
    
    //笔画粗细
    float strokeWidth;
  
    BezierStepStatus status;
    
}
@property(nonatomic,assign) PaintMode paintMode;
@property(nonatomic,assign) PaintLineType paintLineType;
@property(nonatomic,strong) UIColor *color;


@end
