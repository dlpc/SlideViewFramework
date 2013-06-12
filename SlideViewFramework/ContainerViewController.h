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

@property (strong) UIView *secondViewIgnoreView;

@property (assign) CGFloat shadowOpacity;
@property (assign) CGSize shadowOffset;

@property (retain, nonatomic) UIViewController *mainViewController;
@property (retain, nonatomic) UIViewController *firstLayerViewController;
@property (retain, nonatomic) UIViewController *secondLayerViewController;

- (void)slideInFirstLayerView;
- (void)slideToMainView;
- (void)slideToFirstLayerView;
- (void)slideInSecondLayerView;

@property (assign) BOOL firstSlideEnabled;

- (void)enableFirstPaneSlide:(BOOL)enable;

- (void)replaceFirstLayerViewControllerWithViewController:(UIViewController *)newViewController;
- (void)replaceSecondLayerViewControllerWithViewController:(UIViewController *)newViewController;

@end
