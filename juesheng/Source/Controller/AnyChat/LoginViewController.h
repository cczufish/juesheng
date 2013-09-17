//
//  LoginViewController.h
//  AnyChatiPhone
//
//  Created by bairuitech on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LoginViewController : UIViewController {
    
    IBOutlet UITextField    *theUserName;
    IBOutlet UITextField    *thePassword;
    IBOutlet UIButton       *theLoginBtn;
    IBOutlet UIButton       *theSettingsBtn;
    IBOutlet UILabel        *theVersion;
    
    IBOutlet UIButton       *theHideKeyboardBtn;
    
    
}

@property (nonatomic, retain) UITextField   *theUserName;
@property (nonatomic, retain) UITextField   *thePassword;
@property (nonatomic, retain) UIButton      *theLoginBtn;
@property (nonatomic, retain) UIButton      *theSettingsBtn;
@property (nonatomic, retain) UILabel       *theVersion;

@property (nonatomic, retain) UIButton      *theHideKeyboardBtn;


-(IBAction)OnNetConfigBtnClicked:(id)sender;

-(IBAction)OnLoginBtnClicked:(id)sender;

- (IBAction) hideKeyBoard:(id)sender;

@end
