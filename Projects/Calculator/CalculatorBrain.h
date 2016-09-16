//
//  CalculatorBrain.h
//  Calculator
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
{
    double operand;
    NSString *waitingOperation;
    double waitingOperand;
    int origOperand;
    double mStore;
}

- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation :(BOOL) degPressed;

@end
