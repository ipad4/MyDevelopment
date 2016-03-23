//
//  MD_HTTP_URLDecode_VC.m
//  MyDevelopmentTest
//
//  Created by 冯鸿辉 on 16/3/23.
//  Copyright © 2016年 hanyfeng. All rights reserved.
//

#import "MD_HTTP_URLDecode_VC.h"
#import "NSString+URLEncoding.h"

@interface MD_HTTP_URLDecode_VC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *imagePaths;
@end

@implementation MD_HTTP_URLDecode_VC

#pragma mark - < vc lifecycle > -
- (void)viewDidLoad {
  [super viewDidLoad];
  
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [self getWebImg];
}

#pragma mark - < method > -
-(void)urlencode_urldecode{
  NSString *path = @"http://webservice.webxml.com.cn/WebServices/WeatherWS.asmx/getWeather?theCityCode=江门&theUserID=";
  
  //encode
  NSString *encodingString = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *encodingStringC = [encodingString URLEncodedString];//用CoreFoundation提供的C函数编码（更灵活）
  NSLog(@"encode:%@",encodingString);
  NSLog(@"encodeC:%@",encodingStringC);
  
  NSURL *url = [NSURL URLWithString:encodingString];
  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
  
  NSHTTPURLResponse *response = nil;
  NSError *error = nil;
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  if (error) {
    NSLog(@"error:%@",error);
  }else{
    NSLog(@"response:%@",[response allHeaderFields]);
    
    //decode
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    string = [string stringByRemovingPercentEncoding];
    NSLog(@"decode:%@",string);
    
    NSStringEncoding gbkEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *stringGBK = [[NSString alloc] initWithData:data encoding:gbkEncode];////中文GB2312解码（GB2312是国家编码，UTF8是国际通用编码）
    NSLog(@"decode gbk:%@",stringGBK);
    
    NSString *stringC = [string URLDecodedString];//用CoreFoundation提供的C函数解码（更灵活）
    NSLog(@"decodeC:%@",stringC);
  }
}

-(void)GBKencode{
  
  NSStringEncoding gbkEncode = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
  char* c_test = "北京";
  int nLen = strlen(c_test);//长度
  NSString* str = [[NSString alloc]initWithBytes:c_test length:nLen encoding:gbkEncode];
  NSLog(@"str = %@",str);
}

-(void)getWebImg{
  NSURL *url = [NSURL URLWithString:@"http://www.sina.com.cn"];
  NSError *error = nil;
  NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
  if (error) {
    NSLog(@"error:%@",[error localizedDescription]);
  }else{
    NSLog(@"string:%@",htmlString);
  }
  
  //获取页面中所有图片的路径
  self.imagePaths = [NSMutableArray array];
  NSArray *arr = [htmlString componentsSeparatedByString:@"\""];//按"分割源代码（转义字符\"）
  for (NSString *str in arr) {
    if ([str hasSuffix:@"jpg"]) {
      [self.imagePaths addObject:str];
    }
  }
  
  [self.tableView reloadData];
}

#pragma mark - < callback > -
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return self.imagePaths.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if(!cell){
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  NSString *imagePath = self.imagePaths[indexPath.row];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      cell.imageView.image = image;
      [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
      [cell layoutIfNeeded];//手动调用cell的布局方法刷新一下，否则显示会有问题
    });
  });
  
  return cell;
}

@end
