//
//  ViewControllerDetails.m
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 22/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "ViewControllerDetails.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ViewControllerSend.h"


@interface ViewControllerDetails ()

@end

@implementation ViewControllerDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labTitle.text = self.objDetail[@"title"];
    self.txtDescription.text =self.objDetail[@"description"];
    
    NSURL * url =[NSURL URLWithString:self.objDetail[@"picture"][@"original"]];
    
    
    
    [self.imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nvDel:(id)sender {
    
    UIAlertController * alert =[UIAlertController alertControllerWithTitle:@"Deletar Photo" message:@"Deseja deletar?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertYes = [UIAlertAction actionWithTitle:@"YES" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self DeleteDate];
        
    }];
    
    UIAlertAction * alertNo = [UIAlertAction actionWithTitle:@"NO" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:alertYes];
    [alert addAction:alertNo];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
    
    
}
- (IBAction)nvEdit:(id)sender {
    
    ViewControllerSend * view = [self.storyboard instantiateViewControllerWithIdentifier:@"sendViewNew"];
    
    view.objDetail = self.objDetail;
    view.statusTitle.title = @"Editing";
    view.sendAction =  false;
    
    view.mapViewstory = self.mapViewstory;
    
    
    [self.navigationController pushViewController:view animated:YES];
}

-(void) DeleteDate{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Deletando dados!";
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"pictures":self.objDetail[@"id"]
                                 };
    
    NSLog(@"Parameters$$$$$$$$$$$$ %@",parameters );
    //NSLog(@"URL - IMGs$$$$$$$$$$$$ %@",self.urlImg );
    
    
    [manager DELETE:[NSString stringWithFormat:@"http://pos-mobile-ios.herokuapp.com/pictures/%@",self.objDetail[@"id"]] parameters:@"" success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"TUDO OK");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:NO];

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       // NSLog(@"ERRO -- %@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:NO];

        
        
    }];
//    [manager POST:@"http://pos-mobile-ios.herokuapp.com/pictures"
//       parameters:parameters
//constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//    [formData appendPartWithFileData:self.dataImg name:@"picture[picture]" fileName:@"imgsend.jpg" mimeType:@"image/jpeg" ];
//}
//          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//              
//              NSLog(@"TUDO OK");
//              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//              [self.navigationController popViewControllerAnimated:NO];
//              
//          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//              
//              NSLog(@"ERRO!!!!!!!!!!!!!!!!! %@",error );
//              
//              //NSLog(@"IMG!!!!!!!!!!!!!!!!! %@",self.dataImg );
//              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//              [self.navigationController popViewControllerAnimated:NO];
//              
//          }];
//    
    
    
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
