//
//  ContainerViewController.m
//  Lodge
//
//  Created by Heather Snepenger on 9/17/12.
//
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController
@synthesize mainView;
@synthesize firstLayerView;
@synthesize secondLayerView;

@synthesize mainViewController = _mainViewController;
@synthesize firstLayerViewController = _firstLayerViewController;
@synthesize secondLayerViewController = _secondLayerViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateMainView];
    [self updatefirstLayerView];
    [self updateProjectView];
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
    mainView.frame = [self screenSize];
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
    firstLayerView.frame = [self screenSize];
    _firstLayerViewController.view.frame = firstLayerView.frame;
    
    UIImageView *drop_shadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"vc_drop_shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 40, 0)]];
    [drop_shadow setFrame:CGRectMake(-16, -20, 60, [self screenHeight] + 15)];
    [_firstLayerViewController.view addSubview: drop_shadow];
    
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
        [[firstLayerView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)updateSecondLayerView
{
    secondLayerView.frame = [self screenSize];
    _secondLayerViewController.view.frame = secondLayerView.frame;
    
    UIImageView *drop_shadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"vc_drop_shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 40, 0)]];
    [drop_shadow setFrame:CGRectMake(-15, -20, 60, [self screenHeight] + 15)];
    [_secondLayerViewController.view addSubview: drop_shadow];
    
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

- (void) implementMeSlide:(UIPanGestureRecognizer *)sender
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

- (void) implementProjectSlide:(UIPanGestureRecognizer *)sender
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
        [self implementMeSlide:sender];
    }
}

- (void)slideToAccounts
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
//                             self.firstLayerViewController.tableView.scrollEnabled = YES;
                             self.secondLayerViewController.view.userInteractionEnabled = NO;
//                             self.firstLayerViewController.tableView.userInteractionEnabled = YES;
                         }];
    }
    
}

- (void)slideInfirstLayerView
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


- (void) slideTofirstLayerView
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

- (IBAction)donePressed:(id)sender {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.webViewContainer.frame = CGRectMake(0, [self screenHeight], 320, [self screenHeight]);
                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];
}

- (NSString *) versionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];   
    return [NSString stringWithFormat:@"%@", majorVersion];
}

- (void)dealloc {
    [mainView release];
    [firstLayerView release];
    [secondLayerView release];
    
    [_mainViewController release];
    [_firstLayerViewController release];
    [_secondLayerViewController release];
    
    [_webView release];
    [_webViewContainer release];
    [firstLoadIndicator release];
    [super dealloc];
}
@end
