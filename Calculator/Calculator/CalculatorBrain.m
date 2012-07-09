//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Yoel Zumbado on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *) operandStack{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand{
    [self.operandStack addObject: [NSNumber numberWithDouble: operand]];
}

- (double) popOperand{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) {
        [self.operandStack removeLastObject];
    }
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    }else if ([@"*" isEqualToString: operation]) {
        result = [self popOperand] * [self popOperand];
    }else if ([@"-" isEqualToString: operation]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }else if ([@"/" isEqualToString: operation]) {
        double divisor = [self popOperand];
        if (divisor) {
            result = [self popOperand] / divisor;
        }
    }else if ([@"sin" isEqualToString: operation]) {
        result = sin([self popOperand]);
    }else if ([@"cos" isEqualToString: operation]) {
        result = cos([self popOperand]);
    }else if ([@"sqrt" isEqualToString: operation]) {
        result = sqrt([self popOperand]);
    }else if ([@"π" isEqualToString: operation]) {
        result = 3.14159265;
    }else if ([@"+ / -" isEqualToString: operation]) {
        result = [self popOperand] * -1;
    }
    [self pushOperand: result];
    
    return result;
}

-(void)clearBrain{
    [self.operandStack removeAllObjects];
}

- (NSString *) description{
    return [NSString stringWithFormat:@"stack = %@", self.operandStack];
}
@end
