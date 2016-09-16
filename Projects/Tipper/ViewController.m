//
//  ViewController.m
//  tipper
//
//  Created by Shahood Mirza
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)calculateTip:(id)sender {
    
    billTotal = [[billTotalField text] doubleValue];
    
    //tip = billTotal * 0.1;
    [tipTenPercentField setText:[NSString stringWithFormat:@"%.2f",(billTotal*0.1)]];
    [totalTenField setText:[NSString stringWithFormat:@"%.2f",((billTotal*0.1)+billTotal)]];
    
    //tip = billTotal * 0.15;
    [tipFifteenPercentField setText:[NSString stringWithFormat:@"%.2f",(billTotal*0.15)]];
    [totalFifteenField setText:[NSString stringWithFormat:@"%.2f",((billTotal*0.15)+billTotal)]];
    
    //tip = billTotal * 0.2;
    [tipTwentyPercentField setText:[NSString stringWithFormat:@"%.2f",(billTotal*0.2)]];
    [totalTwentyField setText:[NSString stringWithFormat:@"%.2f",((billTotal*0.2)+billTotal)]];
    
    [self customSliderTip:sender];
}

- (IBAction)customSliderTip:(id)sender {
    //[self->billTotalField resignFirstResponder];
    
    billTotal = [[billTotalField text] doubleValue];
    
    custLabel.text = [NSString stringWithFormat:@"%2.0f%%", (roundf(custSlider.value))];
    
    [tipCustField setText:[NSString stringWithFormat:@"%.2f",(billTotal*(roundf(custSlider.value)/100))]];
    [totalCustField setText:[NSString stringWithFormat:@"%.2f",((billTotal*(roundf(custSlider.value)/100)+billTotal))]];
}

- (IBAction)backgroundTap:(id)sender; {
    [self->billTotalField resignFirstResponder];
    
}

///////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
