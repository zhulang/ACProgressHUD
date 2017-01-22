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
}

- (IBAction)clickTest:(UIButton *)sender {
    [ACProgressHUD showScuess:@"成功了"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
