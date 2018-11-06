//
//  SensitiveChecker.swift
//  SensitiveChecker
//
//  Created by 田向阳 on 2018/11/6.
//  Copyright © 2018 田向阳. All rights reserved.
//

import UIKit

class SensitiveChecker {
    
    var tree = [String: Any]()
    var sensitivesWords = [String]()
    public static let shared = SensitiveChecker()
    private let existKey = "existKey"
    
    init() {
        guard let path = Bundle.main.path(forResource: "sensitive", ofType: "txt"), let string = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {return}
        let array = string.components(separatedBy: "|")
        self.sensitivesWords = array
        for string in self.sensitivesWords {
            self.initTree(words: string)
        }
    }
    
    func initTree(words: String){
        var lastNode = [String: Any]()  // 用来记录上一次存储的node
        for index in (0...words.count - 1).reversed() {  //倒叙遍历敏感词
            let subString = words.subString(from: index, to: index + 1)
            if subString.count == 0 {return}
            var newNode = lastNode
            //检测最后一个字符
            if index == words.count - 1 {
                newNode[existKey] = true
                lastNode = newNode
            }

            //检测到第一个字符
            if index == 0 {
                // 判断主树上是否已经存在  如果存在 重新生成新叉
                if var value = self.tree[subString] as? [String : Any] {
                    for key in newNode.keys {
                       value[key] = newNode[key]
                    }
                    self.tree[subString] = value
                }else{
                    self.tree[subString] = newNode
                }
            }else{
                 // 拼接上一个node 并包装在新的树杈上
                newNode = [String: Any]()
                newNode[subString] = lastNode
                lastNode = newNode
            }
        }
    }
    
    public func filterSensitiveWords(text: String) -> (Bool,String) {
        
        if self.tree.count == 0 || text.count == 0 {
            return (false, text)
        }
        
        var content = text
        var result = false
        for i in 0...text.count - 1 {
            let subString = text.subString(from: i, to: text.count)
            var num = 0
            var node = self.tree
            for j in 0...subString.count - 1 {
                let word = subString.subString(from: j, to: j + 1)
                if let value = node[word] {
                    num = num + 1
                    node = value as! [String : Any]
                }else{
                    break
                }
                
                if node[existKey] as? Bool == true {
                    let replaceString = "********************************************"
                    let curString = content.subString(from: i, to: i + num)
                    content = content.replacingOccurrences(of: curString, with: replaceString.subString(from: 0, to: num))
                    result = true
                    break
                }
            }
        }
        
        return (result, content)
    }
    
}

extension String {
    
    public func subString(from: Int, to: Int) -> String {
        if self.count > from && self.count >= to && to > from && from >= 0 {
            let startIndex = self.index(self.startIndex, offsetBy: from)
            let endIndex = self.index(self.startIndex, offsetBy: to)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        }
        return ""
    }
}
