//
//  PopUpViewController.m
//  PopupSample
//
//  Created by 모바일보안팀 on 2017. 3. 22..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked)]) {
        [self.delegate cancelButtonClicked];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
