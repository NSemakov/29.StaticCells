//
//  LoginController.m
//  
//
//  Created by Admin on 10.08.15.
//
//

#import "LoginController.h"

@interface LoginController ()

@end

static NSString* settingsLogin=@"settingLogin";
static NSString* settingsPassword=@"settingsPassword";

static NSString* settingsFirstname=@"settingsFirstname";
static NSString* settingsLastname=@"settingsLastname";
static NSString* settingsAge=@"settingsAge";
static NSString* settingsPhone=@"settingsPhone";
static NSString* settingsEmail=@"settingsEmail";

static NSString* settingsHero=@"settingsHero";
static NSString* settingsMoneyAmount=@"settingsMoneyAmount";



@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UITextField *obj in self.collectionTextFields){
        obj.delegate=self;
    }
    [self loadSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) saveSetting {
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypeLogin-10)] text] forKey:settingsLogin];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypePassword-10)] text] forKey:settingsPassword];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypeFirstname-10)] text] forKey:settingsFirstname];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypeLastname-10)] text] forKey:settingsLastname];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypeAge-10)] text] forKey:settingsAge];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypePhone-10)] text] forKey:settingsPhone];
    [userDef setObject:[[self.collectionTextFields objectAtIndex:(textFieldTypeMail-10)] text] forKey:settingsEmail];
    
    [userDef setInteger:self.ControlHero.selectedSegmentIndex forKey:settingsHero];
    [userDef setDouble:self.sliderMoneyAmount.value forKey:settingsMoneyAmount];
    [userDef synchronize];
}
- (void) loadSetting {
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    UITextField *field=nil;
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypeLogin-10)] ;
    field.text=[userDef objectForKey:settingsLogin];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypePassword-10)] ;
    field.text=[userDef objectForKey:settingsPassword];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypeFirstname-10)] ;
    field.text=[userDef objectForKey:settingsFirstname];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypeLastname-10)] ;
    field.text=[userDef objectForKey:settingsLastname];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypeAge-10)] ;
    field.text=[userDef objectForKey:settingsAge];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypePhone-10)] ;
    field.text=[userDef objectForKey:settingsPhone];
    
    field=[self.collectionTextFields objectAtIndex:(textFieldTypeMail-10)] ;
    field.text=[userDef objectForKey:settingsEmail];
    
    self.sliderMoneyAmount.value=[userDef doubleForKey:settingsMoneyAmount];
    self.ControlHero.selectedSegmentIndex=[userDef integerForKey:settingsHero];
    self.labelMoneyAmount.text=[NSString stringWithFormat:@"%.0f",self.sliderMoneyAmount.value];
}

- (IBAction)actionValueChanged:(id)sender {
    if ([sender isEqual:self.sliderMoneyAmount]) {
        self.labelMoneyAmount.text=[NSString stringWithFormat:@"%.0f",self.sliderMoneyAmount.value];
    }
    [self saveSetting];
}

- (IBAction)actionReturnToDefaults:(UIButton *)sender {
    for (UITextField *obj in self.collectionTextFields){
        obj.text=@"";
    }
    self.sliderMoneyAmount.value=400;
    self.labelMoneyAmount.text=[NSString stringWithFormat:@"%.0f",self.sliderMoneyAmount.value];
    self.ControlHero.selectedSegmentIndex=0;
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==textFieldTypeMail) {
        if ([textField.text isEqualToString:@"wrong"]) {
            textField.text=@"";
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *stringForValidate=[textField.text stringByAppendingString:string];
    //NSLog(@"in field: %@ replacementStr :%@",textField.text,stringForValidate);
    BOOL shouldValidate=YES;
    
    switch (textField.tag) {
        case textFieldTypeFirstname:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[a-zA-Z]+$" maxNumberOfSymbols:7];
            break;
        case textFieldTypeLastname:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[a-zA-Z]+$" maxNumberOfSymbols:7];
            break;
        case textFieldTypeLogin:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@".*" maxNumberOfSymbols:7];
            break;
        case textFieldTypePassword:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@".*" maxNumberOfSymbols:7];
            break;
        case textFieldTypeAge:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[0-9]{1,3}$" maxNumberOfSymbols:3];
            //there is an excess condition. or {1,3} or maxnumber 3. Both are here just for fun.
            break;
        case textFieldTypePhone:
            shouldValidate=[self inputPhoneControl:textField replacingString:string range:range];
            break;
        default:
            break;
    }
    [self saveSetting];
    return shouldValidate;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    BOOL shouldValidate=YES;
    switch (textField.tag) {
        case textFieldTypeMail:
            shouldValidate=[self inputControlString:textField.text WithPattern:@"^[^@]*@{1,1}[^@\\.]+\\.[^\\.@]+$" maxNumberOfSymbols:20];
            //pattern explanation: in the beginning any letters in any amount, then @ (add) only 1,then 1 or more characters which is not @ and not ".", then ".", then 1 or more characters which is not @ and not "." in the end of word.
            if (!shouldValidate) {
                textField.text=@"wrong";
            }
            
            shouldValidate=YES;
            break;
    }
    return shouldValidate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag<textFieldTypeMail) {
        UITextField *nextField=[self.collectionTextFields objectAtIndex:(textField.tag+1-10)];
        [nextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

#pragma mark -Control methods
- (BOOL) inputControlString:(NSString*)str WithPattern:(NSString*) pattern maxNumberOfSymbols:(NSInteger)maxNumberOfSymbols{
    if ([str length]>maxNumberOfSymbols) {
        return NO;
    }
    NSError *err=nil;
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&err];
    
    if (err)
    {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    NSRange rangeOfNSString=[regex rangeOfFirstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    if (rangeOfNSString.location!=NSNotFound) {
        return YES;
    } else {
        return NO;
    }
    
    //NSLog(@"only sentence with NSString: %@",arrayConsistOfSentencesWithNSString);
}

- (BOOL) inputPhoneControl:(UITextField*) textField replacingString:(NSString*) string range:(NSRange) range{
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //+XX (XXX) XXX-XXXX
    
    //NSLog(@"new string = %@", newString);
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    // XXXXXXXXXXXX
    
    // NSLog(@"new string fixed = %@", newString);
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    
    NSMutableString* resultString = [NSMutableString string];
    
    /*
     XXXXXXXXXXXX
     +XX (XXX) XXX-XXXX
     */
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
        
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    textField.text = resultString;
    
    return NO;
    
}

- (void) putText:(NSString*) text intoLabel:(UILabel*) label{
    label.text=text;
}
@end
