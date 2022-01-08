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
    @IBOutlet weak var calculatorDetailTV: UITextView! // 计算步骤
    
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
        if let expressionStr = inputTF.text, expressionStr.count > 0 {
            let expressionR: (expressionList: [String], detailInfoStr: String) = ExpressionUtil.converExpressionToSuffixExpression(expressionStr)
            print(expressionR.expressionList)
            
            
            let str = expressionR.expressionList.joined(separator: "  ") + "\n\n\n\n"
            let calculatorR: (value: Double, detailInfoStr: String) = ExpressionUtil.calculatorExpressionList(expressionR.expressionList, detailStr: str)
            let displyStr = expressionStr + " = " + String(format: "%@", NSNumber(value: calculatorR.value))
            resultDisplayLabel.text = displyStr
            
            let detailStr = "转后缀表达式过程：\n\n" + expressionR.detailInfoStr + "计算后缀表达式过程：\n\n" + calculatorR.detailInfoStr
            calculatorDetailTV.text = detailStr
        }
    }
    
    // MARK: - other
    


}

