//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Yoel Zumbado on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
    @property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    // Test Branch
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject: variable];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack usingVariablesValues:(NSDictionary *) variableValues
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues] + [self popOperandOffProgramStack:stack usingVariablesValues: variableValues];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues] * [self popOperandOffProgramStack:stack usingVariablesValues: variableValues];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues];
            result = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues];
            if (divisor) result = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues] / divisor;
        }else if ([@"sin" isEqualToString: operation]) {
            result = sin([self popOperandOffProgramStack:stack usingVariablesValues: variableValues]);
        }else if ([@"cos" isEqualToString: operation]) {
            result = cos([self popOperandOffProgramStack:stack usingVariablesValues: variableValues]);
        }else if ([@"sqrt" isEqualToString: operation]) {
            result = sqrt([self popOperandOffProgramStack:stack usingVariablesValues: variableValues]);
        }else if ([@"π" isEqualToString: operation]) {
            result = 3.14159265;
        }else if ([@"+ / -" isEqualToString: operation]) {
            result = [self popOperandOffProgramStack:stack usingVariablesValues: variableValues] * -1;
        }else {
            if (variableValues) {
                result = 0;
            }
        }    
    }
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack usingVariablesValues: Nil];
}

+ (double)runProgram:(id)program
usingVariablesValues:(NSDictionary *) variableValues
{
    return 0;
}
    
-(void)clearBrain{
    [self.programStack removeAllObjects];
}

- (NSString *) description{
    return [NSString stringWithFormat:@"stack = %@", self.programStack];
}

@end
