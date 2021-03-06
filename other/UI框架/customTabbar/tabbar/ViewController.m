//
//  ViewController.m
//  tabbar
//
//  Created by 冯鸿辉 on 16/5/9.
//  Copyright © 2016年 DGC. All rights reserved.
//

#import "ViewController.h"
#import "DGCNavigationBarInstance.h"
#import "DGCNavigationViewController.h"
#import "UIView+MDCategory.h"
#import "ViewControllerS1.h"
@interface ViewController ()<DGCNavigationBarInstanceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.addView.backgroundColor = [UIColor yellowColor];
  [self customInitUI];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}

#pragma mark - < method > -
-(void)customInitUI{
  
  [self setBackgroundImage:[UIImage imageNamed:@"home_bg.png"]];
  
  DGCNavigationBarInstance *navigationBar = [[DGCNavigationBarInstance alloc] initWithType:DGCNavigationBarInstanceTypeBack];
  navigationBar.delegate = self;
  [navigationBar setY_:20];
  navigationBar.titleLabel.text = @"vc1";
  [self.navigationBar addSubview:navigationBar];
  
  UIButton *btn1 = [[UIButton alloc] init];
  [btn1 setBackgroundColor:[UIColor redColor]];
  [btn1 setFrame:CGRectMake((self.addView.frame.size.width-200)*0.2, (self.addView.frame.size.height-100)*0.2, 200, 100)];
  [btn1 addTarget:self action:@selector(btn1Tap) forControlEvents:UIControlEventTouchUpInside];
  [self.addView addSubview:btn1];
  
}

#pragma mark - < action > -
-(void)btn1Tap{

  ViewControllerS1 *vc = [ViewControllerS1 new];
  vc.tabBarController_t = self.tabBarController_t;
  [self.navigationController_t pushViewController:vc animated:YES];
}

#pragma mark - < callback > -
-(void)navigationBarInstance:(DGCNavigationBarInstance *)instance leftNavigationBarButtonTap:(id)sender{

}

-(void)navigationBarInstance:(DGCNavigationBarInstance *)instance rightNavigationBarButtonTap:(id)sender{

}




@end
