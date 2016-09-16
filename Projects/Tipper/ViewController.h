//
//  ViewController.h
//  tipper
//
//  Created by Shahood Mirza
//

// Controller.h
// Controller class for the Tipper App

#import <UIKit/UIKit.h>//

@interface ViewController : UIViewController
{
    IBOutlet UITextField *billTotalField; 
    IBOutlet UITextField *tipTenPercentField;
    IBOutlet UITextField *tipFifteenPercentField; 
    IBOutlet UITextField *tipTwentyPercentField;
    IBOutlet UITextField *totalTenField; 
    IBOutlet UITextField *totalFifteenField; 
    IBOutlet UITextField *totalTwentyField;
    IBOutlet UITextField *totalCustField;
    IBOutlet UITextField *tipCustField;
    
    IBOutlet UILabel *custLabel;
    IBOutlet UISlider *custSlider;
    
    //NSString *billTotal; // "Bill Total" field

    float billTotal;
    //float tip;
}

- (IBAction)calculateTip:(id)sender; // calculate the tip
- (IBAction)customSliderTip:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end