//
//  ViewControllerLogin.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 23/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"

@interface ViewControllerLogin : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtLogin;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@property(strong,nonatomic) MBProgressHUD * hud;


@end
