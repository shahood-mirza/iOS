//
//  ViewController.h
//  Calculator
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface ViewController : UIViewController
{
    IBOutlet UILabel *display;
    IBOutlet UILabel *dispCalc;
    IBOutlet UILabel *dispDR;
    CalculatorBrain *brain;
    BOOL userIsInTheMiddleOfTypingANumber;
    BOOL degPressed;
    
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@end
