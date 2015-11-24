//
//  ViewControllerDetails.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "MapViewController.h"


@interface ViewControllerDetails : UIViewController


@property (strong,nonatomic) NSDictionary * objDetail;

@property (strong, nonatomic) IBOutlet UILabel *labTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;


@property (strong, nonatomic) IBOutlet MapViewController *mapViewstory;

@property(strong,nonatomic) MBProgressHUD * hud;

@end
