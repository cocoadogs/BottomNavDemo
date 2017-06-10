//
//  XJHNavigationController.m
//  CustomNavVC
//
//  Created by xujunhao on 2017/6/8.
//  Copyright © 2017年 cocoadogs. All rights reserved.
//


#import "XJHNavigationController.h"

CG_INLINE CGFloat tiptoesHeight() {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
};


@interface XJHNavigationBar : UINavigationBar

@property (nonatomic, strong) UILabel *currentTitleLabel;

@property (nonatomic, strong) UILabel *priorTitleLabel;

@property (nonatomic, strong) UIView *tiptoes;

@end

@implementation XJHNavigationBar



- (UILabel *)currentTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor whiteColor];
    label.text = @"Home";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)priorTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:8];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIView *)tiptoes {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:66.0/255.0f green:69.0/255.0f blue:78.0/255.0f alpha:1.0f];
    return view;
}

#pragma mark - Frame Methods

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.currentTitleLabel = [self currentTitleLabel];
        self.priorTitleLabel = [self priorTitleLabel];
        self.tiptoes = [self tiptoes];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.currentTitleLabel = [self currentTitleLabel];
        self.priorTitleLabel = [self priorTitleLabel];
        self.tiptoes = [self tiptoes];
    }
    return self;
}

@end

@interface XJHNavigationController ()<UINavigationBarDelegate>

@end

@implementation XJHNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithNavigationBarClass:[XJHNavigationBar class] toolbarClass:nil]) {
    }
    self.viewControllers = @[rootViewController];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
    if (self.interactivePopGestureRecognizer) {
        [self.interactivePopGestureRecognizer addTarget:self action:@selector(handleTiptoesDisplay:)];
    }
    [self configNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Gesture Methods

- (void)handleTiptoesDisplay:(UIGestureRecognizer *)gestureRecognizer {
    
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    
    // You can customize the transition style here
    CGFloat positionX = [gestureRecognizer locationInView:self.view].x;
    CGFloat alpha = positionX / self.view.frame.size.width;
    
    // Magic number is to fix the bug that when pan gesture goed half and stop
    bar.currentTitleLabel.alpha = (1-alpha)<0.5 ? (1-alpha)*2 : 1.0; // 1->0
    bar.priorTitleLabel.alpha = alpha>0.5 ? alpha*2-1 : 0;// 0->0
    
}

#pragma mark - UINavigationBarDelegate Methods

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    bar.priorTitleLabel.text = @"";
    bar.priorTitleLabel.hidden = NO;
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    NSString *title = item.title;
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    bar.currentTitleLabel.text = title;
    [bar.currentTitleLabel sizeToFit];
    bar.currentTitleLabel.center = CGPointMake(self.view.center.x, bar.tiptoes.center.y);
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    bar.priorTitleLabel.hidden = NO;
    
    // Get the former viewcontroller
    NSUInteger count = self.viewControllers.count;
    if (count > 0) {
        NSString *title = self.viewControllers[count-1].title;
        bar.priorTitleLabel.text = title;
    }
    
    return YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    
    bar.currentTitleLabel.text = bar.priorTitleLabel.text;
    [bar.currentTitleLabel sizeToFit];
    bar.currentTitleLabel.center = CGPointMake(self.view.center.x, bar.tiptoes.center.y);
    bar.currentTitleLabel.alpha = 1.0f;
    bar.priorTitleLabel.hidden = YES;
    
}

#pragma mark - Private  Methods

/**
 无法正常使用，不能达到在底部显示导航栏的目的，参照XJHBottomNavController.swift，如有解决之方法，欢迎在issue上提供，不胜感激
 */
- (void)configNavigationBar {
    
    XJHNavigationBar *bar = (XJHNavigationBar *)self.navigationBar;
    
    [self.view addSubview:bar.tiptoes];
    [self.view addSubview:bar.currentTitleLabel];
    [self.view addSubview:bar.priorTitleLabel];

    bar.tiptoes.frame = CGRectMake(0, self.view.frame.size.height - tiptoesHeight(), self.view.frame.size.width, tiptoesHeight());
    
    [bar.currentTitleLabel sizeToFit];
    bar.currentTitleLabel.center = CGPointMake(self.view.center.x, bar.tiptoes.center.y);
    bar.priorTitleLabel.frame = bar.currentTitleLabel.frame;
    
}


@end
