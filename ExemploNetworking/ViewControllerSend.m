//
//  ViewControllerSend.m
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "ViewControllerSend.h"
#import "AFNetworking.h"
#import "UIImage+AFNetworking.h"

@interface ViewControllerSend ()

@end

@implementation ViewControllerSend

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.sendAction)
        self.bntEditView.enabled = false;
    else
        self.bntSaveView.enabled = false;
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
[[self navigationController] setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)bntGallery:(id)sender {
    
     [self choosePhotoFromExistingImages];
}

- (IBAction)bntTake:(id)sender {
    
   [self startCameraControllerFromViewController:self usingDelegate:self];
    
}
- (IBAction)bntSend:(id)sender {
    [self saveDate];
    
}
- (IBAction)bntEdit:(id)sender {
    
    
    
    //Depois de salvar os dados voltar para o mapView
    
    [self.navigationController popToViewController:self.mapViewstory animated:NO];
}


-(void) saveDate{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Enviado dados!";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"picture[title]":self.txtTitle.text
                                 ,@"picture[description]":self.txtDescription.text
                                 ,@"picture[lat]":self.strLat
                                 ,@"picture[lng]":self.strLong
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
              [self.navigationController popViewControllerAnimated:NO];
              
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              
              NSLog(@"ERRO!!!!!!!!!!!!!!!!! %@",error );
              
              //NSLog(@"IMG!!!!!!!!!!!!!!!!! %@",self.dataImg );
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              [self.navigationController popViewControllerAnimated:NO];
              
          }];
    
    
    
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
    
}

// Open Camera

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)){
        [MBProgressHUD hideAllHUDsForView:self.parentViewController.view animated:YES];
        self.hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.labelText = @"Atenção";
        self.hud.detailsLabelText = @"Camera não disponível!!";
        [self.hud addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hudWasCancelled)]];
        [self.hud hide:YES afterDelay:3];
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:^{
    }];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
