//
//  ViewController.m
//  Calculator
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (CalculatorBrain *)brain
{
    if (!brain) brain = [[CalculatorBrain alloc] init];
    return brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [[sender titleLabel] text];
    
    if([@"←" isEqual:digit])
    {
        if (!([display.text length] > 1))
        {
            [display setText:(@"0")];
        }
        else if(userIsInTheMiddleOfTypingANumber)
        {
            display.text = [display.text substringToIndex:[display.text length] - 1];
        }
    }
    else if ([@"." isEqual:digit])
    {
        if ([display.text rangeOfString:@"."].location == NSNotFound && userIsInTheMiddleOfTypingANumber)
        {
            [display setText:[[display text] stringByAppendingString:digit]];
        }
        else if ([display.text isEqual:@"0"])
        {
            [display setText:[[display text] stringByAppendingString:digit]];
            userIsInTheMiddleOfTypingANumber = YES;
        }
    }
    else if (userIsInTheMiddleOfTypingANumber && !([display.text isEqual:@"0"]))
    {
        if ([display.text length] < 16)
        {
            [display setText:[[display text] stringByAppendingString:digit]];
        }
    }
    else
    {
        [display setText:digit];
        userIsInTheMiddleOfTypingANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    NSString *operation = [[sender titleLabel] text];
    
    if([@"D/R" isEqual:operation])
    {
        if(!degPressed)
        {
            [dispDR setText:@"Deg"];
            degPressed = YES;
        }
        else
        {
            [dispDR setText:@"Rad"];
            degPressed = NO;
        }
    }
    
    if (userIsInTheMiddleOfTypingANumber) {
        [[self brain] setOperand:[[display text] doubleValue]];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    
    if ([@"CE" isEqual:operation] || [@"=" isEqual:operation])
    {
        [dispCalc setText:@" "];
        userIsInTheMiddleOfTypingANumber = NO;
    }
    else if ([@"÷" isEqual:operation] || [@"×" isEqual:operation] || [@"+" isEqual:operation] || [@"−" isEqual:operation] || [@"mod" isEqual:operation])
    {
        [dispCalc setText:[[dispCalc text] stringByAppendingString:display.text]];
        [dispCalc setText:[[dispCalc text] stringByAppendingString:operation]];
    }
    
    double result = [[self brain] performOperation:operation : degPressed];
    
    if (isinf(result))  //basic error checking
        [display setText:(@"Error")];
    else if (isnan(result))
        [display setText:(@"Error: Invalid Input")];
    else
    {
        if (result < 0.00000000000001 && result > -0.00000000000001) //fix precision with trig functions
            result = round(result);
        
        [display setText:[NSString stringWithFormat:@"%.10g", result]];
    }
}

@end
