//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@class VPImageCropperViewController;
@protocol VPImageCropperDelegate <NSObject>
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController;
@end




@interface VPImageCropperViewController : UIViewController
@property (nonatomic,strong)PHAsset *asset;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<VPImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;//裁剪框的frame
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, assign) CGFloat limitRatio;//放大倍数
- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
