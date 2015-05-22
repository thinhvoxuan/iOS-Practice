//
//  ViewController.swift
//  Calculator
//
//  Created by thinhvoxuan on 5/14/15.
//  Copyright (c) 2015 me.thinhvoxuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTheString = false;
    var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var operandStack = Array<Double>();
    
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTheString {
            enter();
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            } else{
                displayValue = 0
            }
        }
    }
    
    func performOperation(operation:(Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
 
    @IBAction func enter() {
        userIsInTheMiddleOfTheString = false;
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }else{
            displayValue = 0
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(userIsInTheMiddleOfTheString){
            display.text = display.text! + digit
        }else{
            display.text = digit;
            userIsInTheMiddleOfTheString = true
        }
    }
    
    var displayValue : Double{
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTheString = false;
        }
    }

}



