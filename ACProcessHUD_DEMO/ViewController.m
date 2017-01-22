//
//  ViewController.m
//  ACProcessHUD_DEMO
//
//  Created by Achilles on 2017/1/22.
//  Copyright © 2017年 Achilles_Chu. All rights reserved.
//

#import "ViewController.h"
#import "ACProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clickTestButton:(UIButton *)sender {
    [ACProgressHUD showScuess:@"成功导入ACProgressHUD了"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
