//
//  CalculatorBrain.m
//  Calculator
//

#import "CalculatorBrain.h"

@implementation CalculatorBrain

- (void)setOperand:(double)aDouble
{
    operand = aDouble;
}

- (void)performWaitingOperation
{
    if([@"+" isEqual:waitingOperation])
    {
        operand = waitingOperand + operand;
    }
    else if([@"×" isEqual:waitingOperation])
    {
        operand = waitingOperand * operand;
    }
    else if([@"−" isEqual:waitingOperation])
    {
        operand = waitingOperand - operand;
    }
    else if([@"÷" isEqual:waitingOperation])
    {
        operand = waitingOperand / operand;
    }
    else if ([@"mod" isEqual:waitingOperation])
    {
        operand = fmod(waitingOperand, operand);
    }
}

- (double)performOperation:(NSString *)operation : (BOOL) degPressed
{
    if ([@"√" isEqual:operation])
    {
        operand = sqrt(operand);
    }
    else if ([@"+/-" isEqual:operation])
    {
        operand = - operand;
    }
    else if ([@"1/x" isEqual:operation])
    {
        operand = 1/operand;
    }
    else if ([@"x²" isEqual:operation])
    {
        operand = pow(operand, 2);
    }
    else if ([@"x!" isEqual:operation])
    {
        if (operand > 170)
            operand = INFINITY;
        else
        {
            origOperand = operand;
            for(int i=1; i<origOperand; i++)
            {
                operand *= i;
            }
        }
    }
    else if ([@"log₂" isEqual:operation])
    {
        operand = log2(operand);
    }
    else if ([@"log₁₀" isEqual:operation])
    {
        operand = log(operand);
    }
    else if ([@"ln" isEqual:operation])
    {
        operand = log(operand);
    }
    else if ([@"C" isEqual:operation])
    {
        operand = 0;
    }
    else if ([@"CE" isEqual:operation])
    {
        waitingOperation = nil;
        waitingOperand =  0;
        operand = 0;
    }
    else if ([@"MS" isEqual:operation])
    {
        mStore = operand;
    }
    else if ([@"mr" isEqual:operation])
    {
        operand = mStore;
    }
    else if ([@"m+" isEqual:operation])
    {
        mStore += operand;
    }
    else if ([@"m-" isEqual:operation])
    {
        mStore -= operand;
    }
    else if ([@"mc" isEqual:operation])
    {
        mStore = 0;
    }
    else if ([@"π" isEqual:operation])
    {
        operand = M_PI;
    }
    else if ([@"sin" isEqual:operation])
    {
        if (degPressed)
            operand = sin(operand * M_PI/180);
        else
            operand = sin(operand);
    }
    else if ([@"cos" isEqual:operation])
    {
        if (degPressed)
            operand = cos(operand * M_PI / 180);
        else
            operand = cos(operand);
    }
    else if ([@"tan" isEqual:operation])
    {
        if (degPressed)
        {
            if (fmod(operand, 180) == 90)   //tan of any odd multiple of 90deg is infinite
                operand = INFINITY;
            else
                operand = tan(operand * M_PI / 180);
        }
        else
            operand = tan(operand);
    }
    else if ([@"sin⁻¹" isEqual:operation])
    {
        if (degPressed)
            operand = asin(operand * M_PI / 180);
        else
            operand = asin(operand);
    }
    else if ([@"cos⁻¹" isEqual:operation])
    {
        if (degPressed)
            operand = acos(operand * M_PI / 180);
        else
            operand = acos(operand);
    }
    else if ([@"tan⁻¹" isEqual:operation])
    {
        if (degPressed)
            operand = atan(operand * M_PI / 180);
        else
            operand = atan(operand);
    }
    else if ([@"D/R" isEqual:operation])
    {
        if (!degPressed)
            operand = operand * (180/M_PI);             // Radians to Degrees
        else
            operand = operand * (M_PI/180);           // Degrees to Radians
    }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
        
    return operand;
    }

- (id) init
{
    self = [super init];
    if (self) {
        //initialization code here
    }
    
    return self;
}

@end