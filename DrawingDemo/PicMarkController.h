//
//  PicMarkController.h
//  eCamera
//
//  Created by shiguang on 2018/8/23.
//  Copyright © 2018年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicMarkController : UIViewController


@property (nonatomic,copy) void(^ImageBlock)(UIImage *image);

@end
