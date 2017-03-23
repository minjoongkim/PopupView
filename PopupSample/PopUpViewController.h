//
//  PopUpViewController.h
//  PopupSample
//
//  Created by 모바일보안팀 on 2017. 3. 22..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpHelperViewController.h"
@protocol PopupDelegate;


@interface PopUpViewController : UIViewController

@property (assign, nonatomic) id <PopupDelegate>delegate;

@end
