//
//  ViewControllerSend.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"

#import "MapViewController.h"

@interface ViewControllerSend : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property(strong,nonatomic) NSData * dataImg;
@property(strong,nonatomic) NSString *  strLat;
@property(strong,nonatomic) NSString *  strLong;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property(strong,nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) IBOutlet UINavigationItem *statusTitle;
@property (strong, nonatomic) IBOutlet UIButton *bntSaveView;
@property (strong, nonatomic) IBOutlet UIButton *bntEditView;

@property (strong,nonatomic) NSDictionary * objDetail;

@property (strong, nonatomic) IBOutlet MapViewController *mapViewstory;

@property ( nonatomic) BOOL sendAction;


@end
