//
//  MapViewController.h
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import "MBProgressHUD.h"
#import "PointMap.h"

@interface MapViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>

@property(strong,nonatomic) NSArray * jRetorno;
@property (strong, nonatomic) IBOutlet UILabel *labEmail;

@property(strong,nonatomic) NSData * dataImg;
@property (strong, nonatomic) IBOutlet UIButton *bntLogout;

@property(strong,nonatomic) MBProgressHUD * hud;

@property(strong,nonatomic) NSURL * urlImg;

@property (strong,nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property ( nonatomic) BOOL pendenteAutorizar;


@property ( nonatomic) BOOL chamar;






@end
