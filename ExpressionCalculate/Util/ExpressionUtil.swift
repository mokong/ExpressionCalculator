//
//  ExpressionUtil.swift
//  ExpressionCalculate
//
//  Created by MorganWang on 7/1/2022.
//

import Foundation

class ExpressionUtil {
    // 更新: 支持所有的数字的计算, 小数,大于 10 的,小于 10 的都可以
    static func converExpressionToSuffixExpression(_ expressionStr: String) -> ([String], String) {
        var suffixExpressionList: [String] = []
        var operatorExpressionList: [String] = []
        var outoutDetailInfoStr: String = "" // 为显示输出添加，如果不需要可以删除相关代码
        
        var tempNumStr: String = ""
        for item in expressionStr {
            let itemStr = String(item)
            if itemStr == " " {
                continue
            }

            print(suffixExpressionList)
            print(operatorExpressionList)
            print("\n")
            
            outoutDetailInfoStr += "数  字： " + suffixExpressionList.joined(separator: "  ") + "\n\n"
            outoutDetailInfoStr += "符  号： " + operatorExpressionList.joined(separator: "  ") + "\n\n\n\n"

            if item.isNumber == true || item == "." {
                // 是数字则放入表达式中
                tempNumStr += itemStr
            }
            else {
                if tempNumStr.count > 0 {
                    suffixExpressionList.append(tempNumStr)
                    tempNumStr = ""
                }
                if operatorExpressionList.count == 0 {
                    operatorExpressionList.append(itemStr)
                }
                else {
                    // 是运算符，包含"+ - * / ( )"
                    if itemStr == ")" {
                        // 遇到")"，则把数组中的运算符弹出，放入到表达式末尾，直到遇到"("停止
                        let temp: (l1: [String], l2: [String]) = ExpressionUtil.handleAppendExpressionList(operatorExpressionList, suffixList: suffixExpressionList, operatorStr: itemStr)
                        operatorExpressionList = temp.l1
                        suffixExpressionList = temp.l2
                    }
                    else {
                        // 比较运算符的优先级 * / 大于 + -
                        // 如果 item 不大于当前数组里最后一个元素，则数组里最后一个元素弹出，直到优先级大于最后一个元素为止，item 加入
                        // 如果 item 比较中，遇到 ( 且，item 不是 )，则停止
                        let lastStr = operatorExpressionList.last
                        let isItemPriorityHigh = ExpressionUtil.isFirstOperatorPriorityHigh(first: itemStr, second: lastStr!)
                        if isItemPriorityHigh || itemStr == "(" || lastStr == "(" {
                            // item运算符比 last 高，则直接入栈
                            operatorExpressionList.append(itemStr)
                        }
                        else {
                            let temp: (l1: [String], l2: [String]) = ExpressionUtil.handleAppendExpressionList(operatorExpressionList, suffixList: suffixExpressionList, operatorStr: itemStr)
                            operatorExpressionList = temp.l1
                            suffixExpressionList = temp.l2
                            operatorExpressionList.append(itemStr)
                        }
                    }
                }
            }
        }
        if tempNumStr.count > 0 {
            suffixExpressionList.append(tempNumStr)
            tempNumStr = ""
        }
        
        if operatorExpressionList.count > 0 {
            repeat {
                if let tempLastStr = operatorExpressionList.popLast() {
                    suffixExpressionList.append(tempLastStr)
                }
            } while (operatorExpressionList.count > 0)
        }
        
        print(suffixExpressionList)
        print(operatorExpressionList)
        print("\n")
        
        outoutDetailInfoStr += "数  字： " + suffixExpressionList.joined(separator: "  ") + "\n\n"
        outoutDetailInfoStr += "符  号： " + operatorExpressionList.joined(separator: "  ") + "\n\n\n\n"
        
        return (suffixExpressionList, outoutDetailInfoStr)
    }

    // 处理符号数组到表达式数组逻辑
    static func handleAppendExpressionList(_ operatorList: [String], suffixList: [String], operatorStr: String) -> ([String], [String]) {
        var operatorExpressionList = operatorList
        var suffixExpressionList = suffixList
        var lastStr = operatorExpressionList.last
        repeat {
            if let tempLastStr = operatorExpressionList.popLast() {
                lastStr = tempLastStr
                let isItemPriorityHigh = ExpressionUtil.isFirstOperatorPriorityHigh(first: operatorStr, second: tempLastStr)
                if isItemPriorityHigh {
                    operatorExpressionList.append(tempLastStr)
                    break
                }

                if lastStr != "(" {
                    suffixExpressionList.append(tempLastStr)
                }
                else {
                    if operatorStr != ")" { // 只有右括号能消除左括号
                        operatorExpressionList.append("(")
                    }
                }
            }
            else {
                lastStr = ""
            }
        } while ((lastStr != "(") && (lastStr != ""))
        return (operatorExpressionList, suffixExpressionList)
    }


    // 只比较 + - * /
    static func isFirstOperatorPriorityHigh(first: String, second: String) -> Bool {
        let isFirst = ExpressionUtil.isMultiplyOrDivideOperator(itemStr: first)
        let isSecond = ExpressionUtil.isMultiplyOrDivideOperator(itemStr: second)
        if isFirst && !isSecond { // 如果 first 是 * 或者 /，且second 不是 * 或者 /， 则 first高于 second
            return true
        }
        return false
    }

    // 判断运算符优先级
    static func isMultiplyOrDivideOperator(itemStr: String) -> Bool {
        if itemStr == "*" ||
        itemStr == "x" ||
        itemStr == "×" ||
        itemStr == "X" ||
        itemStr == "/" ||
        itemStr == "÷"{
            return true
        }
        return false
    }

    // 后缀表达式的计算
    static func calculatorExpressionList(_ expressionList: [String], detailStr: String) -> (Double, String) {
        
        if expressionList.count == 1 {
            let resultValue = (expressionList.first as NSString?)?.doubleValue ?? 0.0
            return (resultValue, detailStr)
        }
        
        // 计算逻辑如下：
        // 从左到右遍历数组，遇到运算符后，把运算符 op 前面的两个数字a, b取出，按照 a op b 的逻辑计算，并把三个元素从数组中移出
        // 将 运算结果r 插入到数组中计算前 a 的位置
        // 重复遍历数组，按照上面逻辑计算，直到数组中只有一个元素即结果为止
        
        var targetList: [String] = expressionList
        var calculateDetailStr = detailStr // 为显示输出添加，如果不需要可以删除相关代码
        
        for index in 0..<expressionList.count {
            let item = expressionList[index]
            let isOp = ExpressionUtil.isOperator(item)
            if isOp {
                let a = expressionList[index - 2]
                let b = expressionList[index - 1]
                let r = ExpressionUtil.calculator(a, item, b)
                targetList[index - 2] = r
                targetList.removeSubrange(Range(NSRange(location: index-1, length: 2))!)
                break
            }
        }
        print(targetList)
        calculateDetailStr += targetList.joined(separator: "  ") + "\n\n\n\n"
        return ExpressionUtil.calculatorExpressionList(targetList, detailStr: calculateDetailStr)
    }

    // 计算
    static func calculator(_ a: String, _ op: String, _ b: String) -> String {
        var result: Double = 0.0
        
        let aValue = (a as NSString).doubleValue
        let bValue = (b as NSString).doubleValue
        
        switch op {
        case "+":
            result = aValue + bValue
        case "-":
            result = aValue - bValue
        case "*", "×", "x", "X":
            result = aValue * bValue
        case "/", "÷":
            if bValue != 0.0 {
                result = aValue / bValue
            }
        default:
            break
        }
        
        return String(format: "%@", NSNumber(value: result))
    }

    // 是否是运算符
    static func isOperator(_ str: String) -> Bool {
        var result = false
        let isMultipleOrDivide = ExpressionUtil.isMultiplyOrDivideOperator(itemStr: str)
        if isMultipleOrDivide == false {
            if str == "+" ||
                str == "-" {
                result = true
            }
        }
        else {
            result = isMultipleOrDivide
        }
        return result
    }
}
