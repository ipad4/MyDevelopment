//
//  VPImageCropperViewController.m
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import "VPImageCropperViewController.h"
#import "UIImage+Resize.h"
#import "DGCDefine.h"
#import "DGCTool.h"
#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController ()


@property (nonatomic, retain) UIImage *editedImage;
@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;//裁剪框
@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGRect latestFrame;

@end

@implementation VPImageCropperViewController

#pragma mark - < vc lifecycle > -
- (void)dealloc {
  self.originalImage = nil;
  self.showImgView = nil;
  self.editedImage = nil;
  self.overlayView = nil;
  self.ratioView = nil;
  [super dealloc];
}

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio {
  self = [super init];
  if (self) {
    self.cropFrame = cropFrame;
    self.limitRatio = limitRatio;
    self.originalImage = originalImage;
  }
  return self;
}

- (void)viewDidLoad{
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [self customInitUI];
}

#pragma mark - < method > -
#pragma mark 旋屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return NO;
}

#pragma mark customInit
-(void)customInitUI{
  
  [self.view setBackgroundColor:[UIColor purpleColor]];
  
  if (self.asset) {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
      UIImage *img = [UIImage imageWithData:imageData];
      
      DRLog(@"imageOrientation %ld",(long)img.imageOrientation);//3正right 0右up 2反left 1左down
      if (img.imageOrientation == UIImageOrientationUp || img.imageOrientation == UIImageOrientationDown) {//0正常 1裁切后180
        self.originalImage = img;
      }else{
        //最终尺寸
        CGFloat r = img.size.width/1080.f;
        CGFloat w = img.size.width/r;
        CGFloat h = img.size.height/r;
        CGSize size = CGSizeMake(w, h);
        //        DRLog(@"img %@ scale %@",NSStringFromCGSize(img.size),NSStringFromCGSize(size));
        
        UIImage *scaledImage = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
        self.originalImage = scaledImage;
      }
      
      [self initView];
      [self initControlBtn];
    }];
  }else{
    [self initView];
    [self initControlBtn];
  }
  
}
- (void)initView {
  //裁切的时候显示的img
  self.showImgView = [[UIImageView alloc] init];
  [self.showImgView setBackgroundColor:[UIColor greenColor]];
  [self.showImgView setMultipleTouchEnabled:YES];
  [self.showImgView setUserInteractionEnabled:YES];
  [self.showImgView setUserInteractionEnabled:YES];
  [self.showImgView setMultipleTouchEnabled:YES];
  [self.showImgView setImage:self.originalImage];
  [self.view addSubview:self.showImgView];
  
  //计算初始显示frame
  CGFloat oriWidth = self.cropFrame.size.width;//显示宽度 = 屏幕宽度
  CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);//显示高度，即原图高度*（显示宽度/原图宽度），即原图高度 *比例
  CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;//裁剪框原点x
  CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;//裁剪框原点y+（裁剪框高度 - 显示高度）/2
  self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
  self.showImgView.frame = self.oldFrame;
  
  self.latestFrame = self.oldFrame;
  self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
  
  //背景
  self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.overlayView.alpha = 0.5;
  self.overlayView.backgroundColor = [UIColor orangeColor];
  self.overlayView.userInteractionEnabled = NO;
  self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:self.overlayView];
  
  //截取框
  self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
  self.ratioView.layer.borderColor = [UIColor redColor].CGColor;
  self.ratioView.layer.borderWidth = 1.0f;
  self.ratioView.autoresizingMask = UIViewAutoresizingNone;
  [self.view addSubview:self.ratioView];

  //使截取框透明
  [self overlayClipping];
  
  [self addGestureRecognizers];
}

- (void)initControlBtn {
  UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50.0f, 100, 50)];
  cancelBtn.backgroundColor = [UIColor blackColor];
  cancelBtn.titleLabel.textColor = [UIColor whiteColor];
  [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
  [cancelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
  [cancelBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
  [cancelBtn.titleLabel setNumberOfLines:0];
  [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
  [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:cancelBtn];
  
  UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, self.view.frame.size.height - 50.0f, 100, 50)];
  confirmBtn.backgroundColor = [UIColor blackColor];
  confirmBtn.titleLabel.textColor = [UIColor whiteColor];
  [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
  [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
  [confirmBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
  confirmBtn.titleLabel.textColor = [UIColor whiteColor];
  [confirmBtn.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
  [confirmBtn.titleLabel setNumberOfLines:0];
  [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
  [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:confirmBtn];
}



- (void)overlayClipping
{
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  CGMutablePathRef path = CGPathCreateMutable();
  // Left side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0,
                                      0,
                                      self.ratioView.frame.origin.x,
                                      self.overlayView.frame.size.height));
  // Right side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                      0,
                                      self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                      self.overlayView.frame.size.height));
  // Top side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0, 0,
                                      self.overlayView.frame.size.width,
                                      self.ratioView.frame.origin.y));
  // Bottom side of the ratio view
  CGPathAddRect(path, nil, CGRectMake(0,
                                      self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                      self.overlayView.frame.size.width,
                                      self.overlayView.frame.size.height - self.ratioView.frame.origin.y - self.ratioView.frame.size.height));
  maskLayer.path = path;
  self.overlayView.layer.mask = maskLayer;
  CGPathRelease(path);
}

#pragma mark 手势
// register all gestures
- (void) addGestureRecognizers
{
  // add pinch gesture
  UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
  [self.view addGestureRecognizer:pinchGestureRecognizer];
  
  // add pan gesture
  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
  [self.view addGestureRecognizer:panGestureRecognizer];
}

// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
  UIView *view = self.showImgView;
  if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    pinchGestureRecognizer.scale = 1;
  }
  else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    CGRect newFrame = self.showImgView.frame;
    newFrame = [self handleScaleOverflow:newFrame];
    newFrame = [self handleBorderOverflow:newFrame];
    [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
      self.showImgView.frame = newFrame;
      self.latestFrame = newFrame;
    }];
  }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
  UIView *view = self.showImgView;
  if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
    // calculate accelerator
    CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
    CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
    CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
    CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
    CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
    CGPoint translation = [panGestureRecognizer translationInView:view.superview];
    [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
    [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
  }
  else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
    // bounce to original frame
    CGRect newFrame = self.showImgView.frame;
    newFrame = [self handleBorderOverflow:newFrame];
    [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
      self.showImgView.frame = newFrame;
      self.latestFrame = newFrame;
    }];
  }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
  // bounce to original frame
  CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
  if (newFrame.size.width < self.oldFrame.size.width) {
    newFrame = self.oldFrame;
  }
  if (newFrame.size.width > self.largeFrame.size.width) {
    newFrame = self.largeFrame;
  }
  newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
  newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
  return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
  // horizontally
  if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
  if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
  // vertically
  if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
  if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
    newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
  }
  // adapt horizontally rectangle
  if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
    newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
  }
  return newFrame;
}

#pragma mark - < action > -
- (void)cancel:(id)sender {
  if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
    [self.delegate imageCropperDidCancel:self];
  }
}

- (void)confirm:(id)sender {
  if (self.delegate && [self.delegate conformsToProtocol:@protocol(VPImageCropperDelegate)]) {
    [self.delegate imageCropper:self didFinished:[self getSubImage]];
  }
}

-(UIImage *)getSubImage{
  CGRect squareFrame = self.cropFrame;
  CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
  CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
  CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
  CGFloat w = squareFrame.size.width / scaleRatio;
  CGFloat h = squareFrame.size.width / scaleRatio;
  if (self.latestFrame.size.width < self.cropFrame.size.width) {
    CGFloat newW = self.originalImage.size.width;
    CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
    x = 0; y = y + (h - newH) / 2;
    w = newH; h = newH;
  }
  if (self.latestFrame.size.height < self.cropFrame.size.height) {
    CGFloat newH = self.originalImage.size.height;
    CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
    x = x + (w - newW) / 2; y = 0;
    w = newH; h = newH;
  }
  CGRect myImageRect = CGRectMake(x, y, w, h);
  CGImageRef imageRef = self.originalImage.CGImage;
  CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
  CGSize size;
  size.width = myImageRect.size.width;
  size.height = myImageRect.size.height;
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, myImageRect, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
  UIGraphicsEndImageContext();
  CGImageRelease(subImageRef);
  return smallImage;
}

@end
