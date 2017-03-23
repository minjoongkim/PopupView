//
//  PopUpHelperViewController.h
//  PopupSample
//
//  Created by 모바일보안팀 on 2017. 3. 23..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PopupViewController)

@property (nonatomic, retain) UIViewController *popupViewController;
@property (nonatomic, retain) UIView *popupBackgroundView;

- (void)presentPopupViewController:(UIViewController*)popupViewController;
- (void)presentPopupViewController:(UIViewController*)popupViewController dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType;

@end

@protocol PopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked;
@end
