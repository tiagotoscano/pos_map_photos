//
//  ViewController.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 21/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property(strong,nonatomic) NSArray * jRetorno;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtDescription;
@property(strong,nonatomic) NSData * dataImg;
@property(strong,nonatomic) MBProgressHUD * hud;

@property(strong,nonatomic) NSURL * urlImg;

@property (strong,nonatomic) CLLocationManager * locationManager;


@end

