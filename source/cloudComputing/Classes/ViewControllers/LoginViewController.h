//
//  LoginViewController.h
//  cloudComputing
//
//  Created by Minh Tuan on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController{
    IBOutlet UIButton *btnLink;
}
@property (nonatomic, retain) UIViewController *mainView;

- (IBAction)btnLinkClick:(id)sender;
@end
