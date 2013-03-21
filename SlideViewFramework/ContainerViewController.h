//
//  ContainerViewController.h
//  Lodge
//
//  Created by Heather Snepenger on 9/17/12.
//
// 

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

- (id) initWithBaseViewController:(UIViewController *)bViewController andFirst:(UIViewController *)fViewController andSecond:(UIViewController *)sViewController;

@property (strong) UIView *mainView;
@property (strong) UIView *firstLayerView;
@property (strong) UIView *secondLayerView;

@property (assign) CGFloat shadowOpacity;
@property (assign) CGSize shadowOffset;

@property (retain, nonatomic) UIViewController *mainViewController;
@property (retain, nonatomic) UIViewController *firstLayerViewController;
@property (retain, nonatomic) UIViewController *secondLayerViewController;

- (void)slideInFirstLayerView;
- (void)slideToMainView;
- (void)slideToFirstLayerView;
- (void)slideInSecondLayerView;

@end
