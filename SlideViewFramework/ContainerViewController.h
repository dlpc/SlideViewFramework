//
//  ContainerViewController.h
//  Lodge
//
//  Created by Heather Snepenger on 9/17/12.
//
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *firstLayerView;
@property (retain, nonatomic) IBOutlet UIView *secondLayerView;

@property (retain, nonatomic) UIViewController *mainViewController;
@property (retain, nonatomic) UIViewController *firstLayerViewController;
@property (retain, nonatomic) UIViewController *secondLayerViewController;

- (void)slideInMeView;
- (void)slideToAccounts;
- (void)slideToMeView;

@end
