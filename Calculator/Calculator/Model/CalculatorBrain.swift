//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by thinhvoxuan on 5/15/15.
//  Copyright (c) 2015 me.thinhvoxuan. All rights reserved.
//

import Foundation
class CalculatorBrain {

    enum Op : Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        var description : String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_ ) :
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("✕", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("-") {$1 - $0})
        learnOp(Op.BinaryOperation("+", +))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if  !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvalutaion = evaluate(remainingOps)
                if let operand = operandEvalutaion.result {
                    return (operation(operand), operandEvalutaion.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1dEval = evaluate(remainingOps)
                if let operand1 = op1dEval.result {
                    let op2Eval = evaluate(op1dEval.remainingOps)
                    if let operand2 = op2Eval.result {
                        return (operation(operand1, operand2), op2Eval.remainingOps)
                    }
                }
            default:
                break;
            }
        }
        return (nil, ops);
    }
    
    func evaluate() -> Double?{
        let (result, _) = evaluate(opStack)
        return result;
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate();
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation);
        }
        return evaluate()
    }
    
}
