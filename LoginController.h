//
//  LoginController.h
//  
//
//  Created by Admin on 10.08.15.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, textFieldType){
    textFieldTypeFirstname  =12,
    textFieldTypeLastname   =13,
    textFieldTypeLogin      =10,
    textFieldTypePassword   =11,
    textFieldTypeAge        =14,
    textFieldTypePhone      =15,
    textFieldTypeMail       =16
};


@interface LoginController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelMoneyAmount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ControlHero;
@property (weak, nonatomic) IBOutlet UISlider *sliderMoneyAmount;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *collectionTextFields;
- (IBAction)actionValueChanged:(id)sender;
- (IBAction)actionReturnToDefaults:(UIButton *)sender;

@end
