//
//  MapViewController.m
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "MapViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ButtonMap.h"
#import "ViewControllerDetails.h"
#import "ViewControllerSend.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

static  BOOL imgPin;

@interface MapViewController ()


@end

@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    imgPin = true;
    
    self.pendenteAutorizar  = false;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.labEmail.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"email_users"];
    [[self.bntLogout layer] setCornerRadius:10.0f];
    
    NSLog(@"Entrou Did!");
    
    // Do any additional setup after loading the view.
}
- (IBAction)bntLogout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"id_users"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"email_users"];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Efetuando logout!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager DELETE:@"http://pos-mobile-ios.herokuapp.com/users/sign_out"
         parameters:nil
            success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"TUDO OK %@",responseObject);
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:NO];
                
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
                NSLog(@"ERRO!!!!!!!!!!!!!!!!! %@",error );
                
                //NSLog(@"IMG!!!!!!!!!!!!!!!!! %@",self.dataImg );
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:NO];
                
                
            }];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.chamar = true;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    NSLog(@"Animação %i ",animated);
    if(IS_OS_8_OR_LATER){
        // NSLog(@"Entrou IOS!");
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                self.pendenteAutorizar  = true;
                [self.locationManager  requestWhenInUseAuthorization];
                
                // NSLog(@"Entrou!");
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }else{
            // NSLog(@"Entrou ELSE!");
        }
    }
    
    
    
    
    [self addGestureRecognizeToMap];
    [self initLocationService];
    if(!animated){
        
        NSLog(@"Entrou Will!");
        [self getDados];
        [self configureMap];
        
    }
    
    
    
    
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//## Networking

-(void) getDados{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Recebendo dados!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager  manager];
    
    [manager GET:@"http://pos-mobile-ios.herokuapp.com/pictures.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        //NSLog(@"JSON: %@",responseObject);
        
        self.jRetorno = responseObject;
        [self reloadAllpin];
        //[self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Erro: %@",error);
        
    }];
    
    
}


//## Trabalhando com os Pin

-(void) reloadAllpin{
    
    for (id<MKAnnotation> annotation in [self.mapView annotations]) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    
    for (NSDictionary * linha in self.jRetorno) {
        
        
        
        
        
        CLLocation * location  = [[CLLocation alloc] initWithLatitude:[linha[@"lat"] floatValue] longitude:[linha[@"lng"] floatValue]];
        
        // NSLog(@"Titulo: %@",linha[@"title"]);
        [self setPinsOnMap:location setRef:linha];
        
        
        
    }
    
    
    
    
    
}
- (void)setPinsOnMap:(CLLocation *)location setRef:(NSDictionary *) dic{
    
    PointMap *annotation = [[PointMap alloc] init];
    MKCoordinateRegion region ;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    annotation.coordinate = region.center;
    annotation.title = dic[@"title"];
    annotation.subtitle = dic[@"description"];
    annotation.objClick = dic;
    //NSLog(@"Annotation - %@ ",annotation.objClick[@"title"]);
    [self.mapView addAnnotation:annotation];
    
}

- (void)setPinsOnMap:(CLLocation *)location setTitle:(NSString *) title andDescription:(NSString *) description{
    
    PointMap *annotation = [[PointMap alloc] init];
    MKCoordinateRegion region ;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    annotation.coordinate = region.center;
    annotation.title = title;
    annotation.subtitle = description;
    
    
    [self.mapView addAnnotation:annotation];
    
}

- (IBAction)showDetails:(ButtonMap*)sender {
    
    NSLog(@"Click - %@ ",sender.objClick[@"title"]);
    
    ViewControllerDetails * view = [self.storyboard instantiateViewControllerWithIdentifier:@"detailsView"];
    view.mapViewstory = self;
    
    view.objDetail = sender.objClick;
    
    [self.navigationController pushViewController:view animated:YES];
    
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation_old {
    if ([annotation_old isKindOfClass:[MKUserLocation class]])
        return nil;
    
    PointMap *annotation = (PointMap *)annotation_old;
    
    UIImage *image;
    
    
    if(imgPin)
    image  = [UIImage imageNamed:@"pinMapNew"];
    else{
        
        NSURL *url = [NSURL URLWithString:annotation.objClick[@"picture"][@"thumb"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data] ;
        
        image = img;
    
    }
    
    
    
    MKAnnotationView* pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"mapPin"];
    
    pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapPin"];
    pinView.image = image;
    pinView.annotation = annotation;
    pinView.canShowCallout = YES;
    ButtonMap *rightButton = [ButtonMap buttonWithType:UIButtonTypeDetailDisclosure];
    
    rightButton.objClick = annotation.objClick;
    //NSLog(@"bnt - %@ ",rightButton.objClick[@"title"]);
    
    
    
    [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    
    
    return pinView;
    
}


// #### Map
// ### Lembre de marca no Storyboar User Location - caso queira centralizar no usuario.

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if( self.pendenteAutorizar){
        [self configureMap];
        self.pendenteAutorizar  = false;
    }
}

-(void) initLocationService{
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    
    
    
}

-(void) configureMap{
    
    CLLocationCoordinate2D  ctrpoint;
    ctrpoint.latitude = self.locationManager.location.coordinate.latitude;
    ctrpoint.longitude = self.locationManager.location.coordinate.longitude;
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.locationManager.location.coordinate.latitude+0.001555;
    newRegion.center.longitude = self.locationManager.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.005872;
    newRegion.span.longitudeDelta = 0.005863;
    
    [self.mapView setCenterCoordinate:ctrpoint];
    [self.mapView setRegion:newRegion];
}

-(void)addGestureRecognizeToMap{
    
    
    UILongPressGestureRecognizer *tapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    
    tapGesture.minimumPressDuration = 0.5f;
    
    
    
    [self.mapView addGestureRecognizer:tapGesture];
}

- (void)tapMap:(UITapGestureRecognizer*)recognizer {
    
    if (self.chamar){
        self.chamar=false;
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        
        //self.demand.coordinates = touchMapCoordinate;
        CLLocation * location  = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
        
        ViewControllerSend * view = [self.storyboard instantiateViewControllerWithIdentifier:@"sendViewNew"];
        
        
        view.strLat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        view.strLong = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        view.statusTitle.title = @"Insert";
        view.sendAction =  true;
        
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}
- (IBAction)swPinAndImg:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex==0){
        imgPin = true;
    }else{
        imgPin = false;
    }
    [self reloadAllpin];
    
    
}


@end
