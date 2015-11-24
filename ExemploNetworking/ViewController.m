//
//  ViewController.m
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 21/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ViewControllerCell.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@end

@implementation ViewController

// http://pos-mobile-ios.herokuapp.com/pictures.json


- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [self.locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    
    
    self.jRetorno = [[NSArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getDados];
    
    
    
}

-(void) getDados{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Recebendo dados!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager  manager];
    
    [manager GET:@"http://pos-mobile-ios.herokuapp.com/pictures.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSLog(@"JSON: %@",responseObject);
        
        self.jRetorno = responseObject;
        
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Erro: %@",error);
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.jRetorno.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewControllerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    
    NSURL * url =[NSURL URLWithString:self.jRetorno[indexPath.row][@"picture"][@"thumb"]];
    NSLog(@"%@",self.jRetorno[indexPath.row][@"picture"][@"thumb"]);
    [cell.imgViewCell setImageWithURL:url];
    
    cell.labTitle.text = self.jRetorno[indexPath.row][@"title"];
    cell.labDesc.text = self.jRetorno[indexPath.row][@"description"];
    
    
    return cell;
    
}

- (IBAction)bntSend:(id)sender {
    
    [self saveDate];
    
    
    
}



-(void) saveDate{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Enviado dados!";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"picture[title]":self.txtTitle.text
                                 ,@"picture[description]":self.txtDescription.text
                                 ,@"picture[lat]":[NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude]
                                 ,@"picture[lng]":[NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude]
                                 };
    
    NSLog(@"Parameters$$$$$$$$$$$$ %@",parameters );
   //NSLog(@"URL - IMGs$$$$$$$$$$$$ %@",self.urlImg );
    
    [manager POST:@"http://pos-mobile-ios.herokuapp.com/pictures"
    parameters:parameters
    constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.dataImg name:@"picture[picture]" fileName:@"imgsend.jpg" mimeType:@"image/jpeg" ];
        }
    success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
    
        NSLog(@"TUDO OK");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self getDados];
    
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"ERRO!!!!!!!!!!!!!!!!! %@",error );
        
        //NSLog(@"IMG!!!!!!!!!!!!!!!!! %@",self.dataImg );
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self getDados];
        
    }];
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
    
}

//CAMERA
- (IBAction)bntTake:(id)sender {
    
    [self choosePhotoFromExistingImages];
}

- (void) choosePhotoFromExistingImages {
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentViewController: controller animated: YES completion: nil];
        //     [self viewProductImage:controller];
        
    }
    
    
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) info[UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) info[UIImagePickerControllerOriginalImage];
        //self.urlImg =  info[UIim];
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        [self saveImageToUserProfile: imageToSave];
        //[self compressImageAndSave: imageToSave];
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Selecione uma imagem!";
        [self.hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudWasCancelled)]];
        [self.hud hide:YES afterDelay:3];
    }
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)hudWasCancelled{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}


- (void) saveImageToUserProfile: (UIImage *) image {
    CGSize newSize = CGSizeMake(800, 800);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    //Set image by comprssed version;
    
    if (image.size.height > newSize.height) {
        CGRect rect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    self.dataImg = UIImageJPEGRepresentation(image,0.8);
    //NSLog(@"IMGs$$$$$$$$$$$$ %@",self.dataImg );
    [self.imgView setImage:[UIImage imageWithData:self.dataImg]];
}



@end
