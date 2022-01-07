//
//  ViewController.swift
//  ExpressionCalculate
//
//  Created by Horizon on 7/1/2022.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - properties
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var resultDisplayLabel: UILabel!
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    
    // MARK: - init
    
    
    // MARK: - utils
    
    
    // MARK: - action
    
    @IBAction func generateRandomExpression(_ sender: Any) {
        let randomList = [
            "(8 x (7 - (4 * 1)))",
            "8 - 6 / 4 + 1",
            "8 - (6 / 4 + 1)",
            "8 - 6 + 4 * 1",
            "8 - (6 + 4 / 2 - 1) * 2"
        ]
        let randomInt = Int.random(in: 0...randomList.count-1) //dice roll
        let expression = randomList[randomInt]
        inputTF.text = expression
    }
    
    @IBAction func calculate(_ sender: Any) {
        if let expressionStr = inputTF.text {
            let expressionList = ExpressionUtil.converExpressionToSuffixExpression(expressionStr)
            print(expressionList)
            let result = ExpressionUtil.calculatorExpressionList(expressionList)
            let displyStr = expressionStr + " = " + String(format: "%@", NSNumber(value: result))
            resultDisplayLabel.text = displyStr
        }
    }
    
    // MARK: - other
    


}

