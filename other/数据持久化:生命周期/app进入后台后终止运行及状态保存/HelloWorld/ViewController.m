//
//  ViewController.m
//  HelloWorld
//
//  Created by 关东升 on 12-8-24.
//  本书网站：http://www.iosbook1.com
//  智捷iOS课堂：http://www.51work6.com
//  智捷iOS课堂在线课堂：http://v.51work6.com
//  智捷iOS课堂新浪微博：http://weibo.com/u/3215753973
//  作者微博：http://weibo.com/516inc
//  官方csdn博客：http://blog.csdn.net/tonny_guan
//  QQ：1575716557 邮箱：jylong06@163.com
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtField release];
    _txtField = nil;
  
  [_label release];
  _label = nil;
    [super dealloc];
}

//保存
-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
  NSLog(@"保存");
  [super encodeRestorableStateWithCoder:coder];
  [coder encodeObject:self.txtField.text forKey:kSaveKey];
}

//恢复
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
  NSLog(@"恢复");
  [super decodeRestorableStateWithCoder:coder];
  self.txtField.text = [coder decodeObjectForKey:kSaveKey];
}

@end
