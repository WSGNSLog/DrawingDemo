//
//  ViewController.m
//  DrawingDemo
//
//  Created by shiguang on 2018/8/28.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "ViewController.h"
#import "PicMarkController.h"
#import "PhotoBeautyParam.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)drawingDemo:(id)sender {
    WEAKSELF
    PicMarkController *picVC = [[PicMarkController alloc]init];
    picVC.ImageBlock = ^(UIImage *image) {
        weakSelf.imageView.image = image;
    };
    [self presentViewController:picVC animated:YES completion:nil];
}

@end
