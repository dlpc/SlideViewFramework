//
//  ContainerViewController.m
//  Lodge
//
//  Created by Heather Snepenger on 9/17/12.
//
//

#import "ContainerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULT_SHADOW_WIDTH -3.0
#define DEFAULT_SHADOW_HEIGHT 0.5
#define DEFAULT_SHADOW_OPACITY 0.5

static NSInteger height;
static CGRect size;

@interface ContainerViewController ()

@end

@implementation ContainerViewController
@synthesize mainView;
@synthesize firstLayerView;
@synthesize secondLayerView;

@synthesize mainViewController = _mainViewController;
@synthesize firstLayerViewController = _firstLayerViewController;
@synthesize secondLayerViewController = _secondLayerViewController;



//Custom init for 3 VCs
- (id)initWithBaseViewController:(UIViewController *)bViewController andFirst:(UIViewController *)fViewController andSecond:(UIViewController *)sViewController
{
    self = [super init];
    if(self){
        [self setMainViewController:bViewController];
        [self setFirstLayerViewController:fViewController];
        [self setSecondLayerViewController:sViewController];
    }
    return self;
}

- (void)loadView{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor greenColor];
    self.view = contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainView = [[UIView alloc] initWithFrame:[self screenSize]];
    self.firstLayerView = [[UIView alloc] initWithFrame:[self screenSize]];
    self.secondLayerView = [[UIView alloc] initWithFrame:[self screenSize]];
    
    [self.view addSubview:mainView];
    [self.view addSubview:firstLayerView];
    [self.view addSubview:secondLayerView];
    
    [self updateMainView];
    [self updateFirstLayerView];
    [self updateSecondLayerView];
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(implementFirstLayerSlide:)];
    [self.firstLayerView addGestureRecognizer:gesture];
    
    UIPanGestureRecognizer *projectGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(implementSecondLayerSlide:)];
    [self.secondLayerView addGestureRecognizer:projectGesture];
    
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setMainView:nil];
    [self setFirstLayerView:nil];
    [self setSecondLayerView:nil];
    
    [self setMainViewController:nil];
    [self setFirstLayerViewController:nil];
    [self setSecondLayerViewController:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)updateMainView
{
    _mainViewController.view.frame = mainView.frame;
    
    [mainView addSubview:_mainViewController.view];
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
    _mainViewController = mainViewController;
    
    // handle view controller hierarchy
    if(_mainViewController){
        [self addChildViewController:_mainViewController];
        [_mainViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            [self updateMainView];
        }
    }else{
        [[mainView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)updateFirstLayerView
{
    _firstLayerViewController.view.frame = firstLayerView.frame;
    
    [self addDropShadow:self.firstLayerView];
    
    [firstLayerView addSubview:_firstLayerViewController.view];
}

- (void)setFirstLayerViewController:(UIViewController *)firstLayerViewController
{
    _firstLayerViewController = firstLayerViewController;
    
    // handle view controller hierarchy
    if(_firstLayerViewController){
        [self addChildViewController:_firstLayerViewController];
        [_firstLayerViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            [self updateFirstLayerView];
        }
    }else{
        [[firstLayerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)updateSecondLayerView
{
    _secondLayerViewController.view.frame = secondLayerView.frame;
    
    [self addDropShadow:self.secondLayerView];
    
    [secondLayerView addSubview:_secondLayerViewController.view];
}

- (void)setSecondLayerViewController:(UIViewController *)secondLayerViewController
{
    _secondLayerViewController = secondLayerViewController;
    
    // handle view controller hierarchy
    if(_secondLayerViewController){
        [self addChildViewController:_secondLayerViewController];
        [_secondLayerViewController didMoveToParentViewController:self];
        
        if ([self isViewLoaded]) {
            [self updateSecondLayerView];
        }
    }else{
        [[secondLayerView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) implementFirstLayerSlide:(UIPanGestureRecognizer *)sender
{
    
    if([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged){
        
        CGPoint translation = [sender translationInView:[self.firstLayerView superview]];
        [self.firstLayerView setCenter:CGPointMake(MAX([self.firstLayerView center].x + translation.x, 160),  [self.firstLayerView center].y)];
        [sender setTranslation:CGPointZero inView:[self.firstLayerView superview]];
        
        if(self.firstLayerView.frame.origin.x > 260){
            [self.secondLayerView setCenter:CGPointMake(MAX([self.secondLayerView center].x + translation.x, 160),  [self.secondLayerView center].y)];
            [sender setTranslation:CGPointZero inView:[self.secondLayerView superview]];
        }
        
    }else if([sender state] == UIGestureRecognizerStateEnded){
        CGPoint velocity = [sender velocityInView:self.view];
        if(self.firstLayerView.frame.origin.x < 200){
            
            if(velocity.x > 100){
                if(self.firstLayerView.frame.origin.x < 275){
                    
                    float distance = abs(self.firstLayerView.frame.origin.x - 290);
                    float time = MIN(distance / velocity.x, 0.3);

                    [UIView animateWithDuration:time
                                     animations:^{
                                         self.secondLayerView.frame = CGRectMake(315, 0, 320, [self screenHeight]);
                                         self.firstLayerView.frame = CGRectMake(290, 0, 320, [self screenHeight]);
                                     }
                                     completion:^(BOOL finished){
                                         
                                         [UIView animateWithDuration:0.15
                                                          animations:^{
                                                              self.secondLayerView.frame = CGRectMake(310, 0, 320, [self screenHeight]);
                                                              self.firstLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                                              
                                                          }
                                                          completion:^(BOOL finished){
                                                              self.secondLayerViewController.view.userInteractionEnabled = NO;
                                                          }];
                                         
                                     }];
                }else {
                    
                    float distance = abs(self.firstLayerView.frame.origin.x - 275);
                    float time = MIN(distance / velocity.x, 0.3);
                    
                    [UIView animateWithDuration:time
                                     animations:^{
                                         self.secondLayerView.frame = CGRectMake(310, 0, 320, [self screenHeight]);
                                         self.firstLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                         
                                     }
                                     completion:^(BOOL finished){
                                         self.secondLayerViewController.view.userInteractionEnabled = NO;
                                     }];
                }
            }else{
                                
                float distance = abs(self.firstLayerView.frame.origin.x);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                 animations:^{
                                     self.firstLayerView.frame = CGRectMake(0, 0, 320, [self screenHeight]);
                                     self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                 }
                                 completion:^(BOOL finished) {
//                                     self.firstLayerViewController.tableView.scrollEnabled = YES;
                                     self.secondLayerViewController.view.userInteractionEnabled = NO;
//                                     self.firstLayerViewController.tableView.userInteractionEnabled = YES;
                                 }
                 ];
            }
            
        }else {
            
            if(self.firstLayerView.frame.origin.x < 275){
                
                float distance = abs(self.firstLayerView.frame.origin.x - 290);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                 animations:^{
                                     self.secondLayerView.frame = CGRectMake(315, 0, 320, [self screenHeight]);
                                     self.firstLayerView.frame = CGRectMake(290, 0, 320, [self screenHeight]);
                                 }
                                 completion:^(BOOL finished){
                                     
                                     [UIView animateWithDuration:0.15
                                                      animations:^{
                                                          self.secondLayerView.frame = CGRectMake(310, 0, 320, [self screenHeight]);
                                                          self.firstLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                                      }
                                                      completion:^(BOOL finished){
                                                          self.secondLayerViewController.view.userInteractionEnabled = NO;
                                                      }];
                                     
                                 }];
            }else {
                
                float distance = abs(self.firstLayerView.frame.origin.x - 275);
                float time = MIN(distance / velocity.x, 0.3);
                
                [UIView animateWithDuration:time
                                 animations:^{
                                     self.secondLayerView.frame = CGRectMake(310, 0, 320, [self screenHeight]);
                                     self.firstLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                 }
                                 completion:^(BOOL finished){
                                     self.secondLayerViewController.view.userInteractionEnabled = NO;
                                 }];
            }
            
        }
    }
}

- (void) implementSecondLayerSlide:(UIPanGestureRecognizer *)sender
{
    if(self.firstLayerView.frame.origin.x < 2){
        if([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged){
            
            CGPoint translation = [sender translationInView:[sender.view superview]];
            [sender.view setCenter:CGPointMake(MAX([sender.view center].x + translation.x, 160), [sender.view center].y)];
            [sender setTranslation:CGPointZero inView:[sender.view superview]];
            
        }else if([sender state] == UIGestureRecognizerStateEnded){
            CGPoint velocity = [sender velocityInView:self.view];
            if(self.secondLayerView.frame.origin.x < 200){
                
                if(velocity.x > 100){
                    
                    float distance = abs(self.secondLayerView.frame.origin.x - 290);
                    float time = MIN(distance / velocity.x, 0.3);
                    
                    if(self.secondLayerView.frame.origin.x < 275){
                        [UIView animateWithDuration:time
                                         animations:^{
                                             self.secondLayerView.frame = CGRectMake(290, 0, 320, [self screenHeight]);
                                         }
                                         completion:^(BOOL finished){
                                             
                                             [UIView animateWithDuration:0.15
                                                              animations:^{
                                                                  self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                                                  
                                                              }
                                                              completion:^(BOOL finished){
                                                                  self.secondLayerViewController.view.userInteractionEnabled = NO;
                                                                  self.secondLayerViewController.navigationItem.leftBarButtonItem.enabled = NO;
                                                              }];
                                             
                                         }];
                    }else {
                        
                        float distance = abs(self.secondLayerView.frame.origin.x - 275);
                        float time = MIN(distance / velocity.x, 0.3);
                        [UIView animateWithDuration:time
                                         animations:^{
                                             self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                             
                                         }
                                         completion:^(BOOL finished){
                                             self.secondLayerViewController.view.userInteractionEnabled = NO;
                                            self.secondLayerViewController.navigationItem.leftBarButtonItem.enabled = NO;
                                         }];
                    }
                }else{
                    float distance = abs(self.secondLayerView.frame.origin.x);
                    float time = MIN(distance / velocity.x, 0.3);
                    [UIView animateWithDuration:time
                                     animations:^{
                                         self.secondLayerView.frame = CGRectMake(0, 0, 320, [self screenHeight]);
                                     }
                                     completion:^(BOOL finished) {
                                         self.secondLayerViewController.view.userInteractionEnabled = YES;
                                         self.secondLayerViewController.navigationItem.leftBarButtonItem.enabled = YES;
                                     }
                     ];
                }
                
            }else {
                float distance = abs(self.secondLayerView.frame.origin.x - 275);
                float time = MIN(distance / velocity.x, 0.3);
                [UIView animateWithDuration:time
                                 animations:^{
                                     self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                                 }
                                 completion:^(BOOL finished) {
                                     self.secondLayerViewController.view.userInteractionEnabled = NO;
                                     self.secondLayerViewController.navigationItem.leftBarButtonItem.enabled = NO;
                                 }
                 ];
            }
        }
    } else {
        [self implementFirstLayerSlide:sender];
    }
}

- (void)slideToMainView
{
    if(self.firstLayerView.frame.origin.x < 5){
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.secondLayerView.frame = CGRectMake(310, 0, 320, [self screenHeight]);
                             self.firstLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                         }
                         completion:^(BOOL finished){
                             self.secondLayerViewController.view.userInteractionEnabled = NO;
                         }];
    }else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                             self.firstLayerView.frame = CGRectMake(0, 0, 320, [self screenHeight]);
                         }
                         completion:^(BOOL finished){
                             self.secondLayerViewController.view.userInteractionEnabled = NO;
                         }];
    }
    
}

- (void)slideInFirstLayerView
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         self.firstLayerView.frame = CGRectMake(0, 0, 320, [self screenHeight]);
                         self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                     }
                     completion:^(BOOL finished){
                         self.firstLayerViewController.view.userInteractionEnabled = YES;
                         self.secondLayerViewController.view.userInteractionEnabled = NO;
                     }];
}


- (void) slideToFirstLayerView
{
    if(self.secondLayerView.frame.origin.x < 5){
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.secondLayerView.frame = CGRectMake(275, 0, 320, [self screenHeight]);
                         }
                         completion:^(BOOL finished) {
                             self.firstLayerViewController.view.userInteractionEnabled = YES;
                             self.secondLayerViewController.view.userInteractionEnabled = NO;
                         }
         ];
    }else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.secondLayerView.frame = CGRectMake(0, 0, 320, [self screenHeight]);
                         }
                         completion:^(BOOL finished) {
                             self.secondLayerViewController.view.userInteractionEnabled = YES;
                         }
         ];
    }
}

- (void) addDropShadow:(UIView *)mView
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:mView.bounds];
    mView.layer.masksToBounds = NO;
    mView.layer.shadowColor = [UIColor blackColor].CGColor;
    if(self.shadowOffset.width == 0 && self.shadowOffset.height == 0)
        mView.layer.shadowOffset = CGSizeMake(DEFAULT_SHADOW_WIDTH, DEFAULT_SHADOW_HEIGHT);
    else mView.layer.shadowOffset = self.shadowOffset;
    if (self.shadowOpacity == 0)
        mView.layer.shadowOpacity = DEFAULT_SHADOW_OPACITY;
    else mView.layer.shadowOpacity = self.shadowOpacity;
    
    mView.layer.shadowPath = shadowPath.CGPath;
}


#pragma mark -
#pragma mark Screen Util
- (NSInteger) screenHeight
{
    if (!height) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        height = (int)screenHeight;
    }
    return height;
}

- (CGRect) screenSize
{
    if(size.size.width == 0)
        size = [[UIScreen mainScreen] bounds];
    return size;
}
@end
