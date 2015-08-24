//
//  ViewController.m
//  TestShareSDKUI
//
//  Created by 刘 靖煌 on 15/7/6.
//  Copyright (c) 2015年 mob. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "SSUIShareActionSheetCustomItem.h"
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setFrame:CGRectMake(self.view.frame.size.width/2 - 100, 100, 200, 25)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"Show ContentEditor View" forState:UIControlStateNormal];
    [btn2 sizeToFit];
    btn2.frame = CGRectMake((self.view.frame.size.width - 200)/2, 200, 200, 50);
    [btn2 addTarget:self action:@selector(ShowShareContentEditorView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

#pragma mark -

- (void)btnClickHandler:(id)sender
{
    //1、构造分享内容
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"ShareSDK is the most comprehensive Social SDK in the world , which share easily with 40+ platforms , from around the world.For more information,please visit http://www.mob.com website."
                                images:@[@"http://www.mob.com/AssetsMob/images/index/video-img1.png"]
                                   url:[NSURL URLWithString:@"http://www.mob.com"]
                                 title:@"分享标题"
                                  type:SSDKContentTypeImage];
    
    //1.2、自定义分享平台（非必要）
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"Icon.png"]
                                                                                  label:@"自定义"
                                                                                onClick:^{
                                                                                    
                                                                                    NSLog(@"=== 自定义item点击 ===");
                                                                                }];
    [activePlatforms addObject:item];
    
    //1.3、自定义分享编辑页面（非必要）
//    [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];
//    [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
//    [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
//    [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
//    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:10]];
//    [SSUIShareActionSheetStyle setCurrentPageIndicatorTintColor:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0]];
//    [SSUIShareActionSheetStyle setPageIndicatorTintColor:[UIColor colorWithRed:62/255.0 green:62/255.0 blue:62/255.0 alpha:1.0]];
//    [SSUIShareActionSheetStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskLandscape];
    
    //1.4、自定义支持的屏幕方向
    [ShareSDK setSupportedInterfaceOrientation:UIInterfaceOrientationMaskAllButUpsideDown];
    
    //2、弹出分享菜单栏
//    SSUIShareActionSheetController *actionSheet = [ShareSDK showShareActionSheet:sender
    [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:params
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   if (state == SSDKResponseStateSuccess)
                   {
                       NSLog(@"分享成功");
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                       message:nil
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil, nil];
                       [alert show];
                   }
                   else if(state == SSDKResponseStateFail)
                   {
                       if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信；"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                       }
                       else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                       }
                       else
                       {
                           NSLog(@"分享失败");
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                       }
                   }
               }];
    
//    [actionSheet.directSharePlatforms removeObject:@(SSDKPlatformTypeWechat)];
}

-(void)ShowShareContentEditorView:(id*)sender
{
    SSDKImage* urlImage = [[SSDKImage alloc] initWithURL:[NSURL URLWithString:@"http://img4.duitang.com/uploads/item/201303/14/20130314114434_M3fej.thumb.600_0.jpeg"]];
    NSArray* imgArr = @[urlImage];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"ShareSDK is the most comprehensive Social SDK in the world , which share easily with 40+ platforms , from around the world.For more information,please visit http://www.mob.com website."
                                images:imgArr
                                   url:nil
                                 title:nil
                                  type:SSDKContentTypeImage];
    [params SSDKSetupSinaWeiboShareParamsByText:@"sina text-test"
                                          title:@"微博测试标题"
                                          image:urlImage
                                            url:nil
                                       latitude:40.413467
                                      longitude:116.646439
                                       objectID:nil
                                           type:SSDKContentTypeImage];
    [params SSDKSetupFacebookParamsByText:@"Facebook text-test" image:urlImage type:SSDKContentTypeImage];
    [params SSDKSetupTencentWeiboShareParamsByText:@"TencentWeibo xt-test" images:imgArr latitude:34.12 longitude:54.05 type:SSDKContentTypeImage];
    
    NSArray* othetplarForms = [NSArray arrayWithObjects:@(SSDKPlatformTypeTencentWeibo),@(SSDKPlatformTypeFacebook),@(SSDKPlatformTypeTwitter) ,nil];

//    [SSUIEditorViewStyle setTitle:@"自定义标题"];
//    [SSUIEditorViewStyle setTitleColor:[UIColor yellowColor]];
//        [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundImage:[UIImage imageNamed:@"wenBG.jpg"]];
//       [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor purpleColor]];
//    [SSUIEditorViewStyle setiPadNavigationBarBackgroundColor:[UIColor lightGrayColor]];
//    [SSUIEditorViewStyle setCancelButtonLabel:@"ccccc"];
//    [SSUIEditorViewStyle setCancelButtonImage:[UIImage imageNamed:@"wenButton.jpg"]];
//    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor blueColor]];
//    
//    [SSUIEditorViewStyle setShareButtonImage:[UIImage imageNamed:@"wenButton.jpg"]];
//    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor greenColor]];
//    [SSUIEditorViewStyle setShareButtonLabel:@"right"];
//    [SSUIEditorViewStyle setContentViewBackgroundColor:[UIColor brownColor]];
//    [SSUIEditorViewStyle setSupportedInterfaceOrientation:UIInterfaceOrientationMaskLandscape];
    
    [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo
           otherPlatformTypes:othetplarForms
                  shareParams:params
          onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        if (state == SSDKResponseStateSuccess)
        {
            NSLog(@"平台:%lu 分享成功！",(unsigned long)platformType);
            NSLog(@"平台:%@ 分享的图片！",[contentEntity images]);
            
        }
        if (state == SSDKResponseStateFail)
        {
            NSLog(@"平台:%lu 分享失败,错误信息:\n%@",(unsigned long)platformType,error);
        }
        
        if (state == SSDKResponseStateCancel)
        {
            NSLog(@"平台:%lu 取消分享",(unsigned long)platformType);
        }
    }];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation == self.preferredInterfaceOrientationForPresentation);
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationLandscapeRight;
//}
//
////iOS 6
//- (BOOL) shouldAutorotate
//{
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

@end
