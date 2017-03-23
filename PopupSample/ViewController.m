//
//  ViewController.m
//  PopupSample
//
//  Created by 모바일보안팀 on 2017. 3. 22..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "ViewController.h"
#import "PopUpViewController.h"

@interface ViewController () <PopupDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cancelButtonClicked
{
    [self dismissPopupViewControllerWithanimationType];
}
-(IBAction)openPopupView:(id)sender {
    
    PopUpViewController *secondDetailViewController = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    secondDetailViewController.delegate = self;
    
    [self presentPopupViewController:secondDetailViewController];
    
}
@end
