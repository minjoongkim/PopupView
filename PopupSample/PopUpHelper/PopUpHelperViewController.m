//
//  PopUpHelperViewController.m
//  PopupSample
//
//  Created by 모바일보안팀 on 2017. 3. 23..
//  Copyright © 2017년 KMJ. All rights reserved.
//

#import "PopUpHelperViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35
#define kPopupViewController @"kPopupViewController"
#define kPopupBackgroundView @"kPopupBackgroundView"
#define kSourceViewTag 860821
#define kPopupViewTag 170219
#define kOverlayViewTag 871208

@interface UIViewController (PopupViewControllerPrivate)
- (UIView*)topView;
- (void)presentPopupView:(UIView*)popupView;
@end

static NSString *PopupViewDismissedKey = @"PopupViewDismissed";

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (PopupViewController)

static void * const keypath = (void*)&keypath;

- (UIViewController*)popupViewController {
    return objc_getAssociatedObject(self, kPopupViewController);
}

- (void)setPopupViewController:(UIViewController *)popupViewController {
    objc_setAssociatedObject(self, kPopupViewController, popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIView*)popupBackgroundView {
    return objc_getAssociatedObject(self, kPopupBackgroundView);
}

- (void)setPopupBackgroundView:(UIView *)temppopupBackgroundView {
    objc_setAssociatedObject(self, kPopupBackgroundView, temppopupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)presentPopupViewController:(UIViewController*)popupViewController dismissed:(void(^)(void))dismissed
{
    self.popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view dismissed:dismissed];
}

- (void)presentPopupViewController:(UIViewController*)popupViewController
{
    [self presentPopupViewController:popupViewController dismissed:nil];
}

- (void)dismissPopupViewControllerWithanimationType
{
    UIView *sourceView = [self topView];
    UIView *popupView = [sourceView viewWithTag:kPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kOverlayViewTag];
    
    
    [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
}



////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling

- (void)presentPopupView:(UIView*)popupView
{
    [self presentPopupView:popupView dismissed:nil];
}

- (void)presentPopupView:(UIView*)popupView  dismissed:(void(^)(void))dismissed
{
    UIView *sourceView = [self topView];
    sourceView.tag = kSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.popupBackgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
    self.popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.popupBackgroundView.backgroundColor = [UIColor blackColor];
    self.popupBackgroundView.alpha = 0.0f;
    [overlayView addSubview:self.popupBackgroundView];
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimation:) forControlEvents:UIControlEventTouchUpInside];
    [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
    [self setDismissedCallback:dismissed];
}

-(UIView*)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissPopupViewControllerWithanimation:(id)sender
{
    [self dismissPopupViewControllerWithanimationType];
}

//////////////////////////////////////////////////////////////////////////////

#pragma mark --- Fade

- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.popupViewController viewWillAppear:NO];
        self.popupBackgroundView.alpha = 0.5f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.popupViewController viewDidAppear:NO];
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.popupViewController viewWillDisappear:NO];
        self.popupBackgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.popupViewController viewDidDisappear:NO];
        self.popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil)
        {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark -
#pragma mark Category Accessors

#pragma mark --- Dismissed

- (void)setDismissedCallback:(void(^)(void))dismissed
{
    objc_setAssociatedObject(self, &PopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback
{
    return objc_getAssociatedObject(self, &PopupViewDismissedKey);
}

@end
