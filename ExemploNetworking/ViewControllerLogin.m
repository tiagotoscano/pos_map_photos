//
//  ViewControllerLogin.m
//  ExemploNetworking
//
//  Created by Tiago Pinheiro on 23/11/15.
//  Copyright © 2015 Tiago Pinheiro. All rights reserved.
//

#import "ViewControllerLogin.h"
#import "AFNetworking.h"
#import "MapViewController.h"


@interface ViewControllerLogin ()

@end

@implementation ViewControllerLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"id_users"] !=nil) {
        
        MapViewController * view =[self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
        [self.navigationController pushViewController:view animated:NO];
        
    }
    
    
    // Do any additional setup after loading the view.

}
-(void)viewWillAppear:(BOOL)animated{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    [self login];

    return NO;

}

//
//- (IBAction)btnSave:(id)sender {
//    
//    
//    [self login];
//    
//    
//}
-(BOOL) login{

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    //hub.mode = MBProgressHUDModeText;
    self.hud.labelText = @"Efetuando login!";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSDictionary *parameters = @{@"user[email]":self.txtLogin.text
                                 ,@"user[password]":self.txtPassword.text
                                 };
    
    NSLog(@"Parameters$$$$$$$$$$$$ %@",parameters );
    //NSLog(@"URL - IMGs$$$$$$$$$$$$ %@",self.urlImg );
    
    [manager POST:@"http://pos-mobile-ios.herokuapp.com/users/sign_in.json"
       parameters:parameters
          success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
              
              NSLog(@"TUDO OK %@",responseObject);
              
              NSDictionary * dicReturn = responseObject;
              
              
              [[NSUserDefaults standardUserDefaults] setValue:dicReturn[@"id"] forKey:@"id_users"];
              [[NSUserDefaults standardUserDefaults] setValue:dicReturn[@"email"] forKey:@"email_users"];
              self.txtLogin.text = nil;
              self.txtPassword.text=nil;
              [self.txtLogin becomeFirstResponder];
              
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              
              MapViewController * view =[self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
              [self.navigationController pushViewController:view animated:NO];
              
              
          } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
              
              NSLog(@"ERRO!!!!!!!!!!!!!!!!! %@",error );
              
              //NSLog(@"IMG!!!!!!!!!!!!!!!!! %@",self.dataImg );
              
              //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              self.hud.mode = MBProgressHUDModeText;
              self.hud.labelText = @"ERRO LOGIN";
              
              [self.hud addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelHud)]];
              
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              });
              
              
              
          }];

   return NO;

}

-(void) cancelHud{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return true;
    
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
