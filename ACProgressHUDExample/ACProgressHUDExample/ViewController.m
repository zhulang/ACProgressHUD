//
//  ViewController.m
//  ACProgressHUDExample
//
//  Created by Achilles on 2017/1/22.
//  Copyright © 2017年 Achilles_Chu. All rights reserved.
//
#import "ACProgressHUD.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ACProgressHUD setToastBackgroundColor:236 green:34 blue:219 andAlpha:0.5];
    [ACProgressHUD setBackgroundColor:34 green:236 blue:219 andAlpha:0.5];
}

- (IBAction)clickTest:(UIButton *)sender {
//    [ACProgressHUD toastScuess:@"成功了"];
    [ACProgressHUD showScuess:@"成功了"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
