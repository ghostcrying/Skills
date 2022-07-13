//
//  main.swift
//  string_secrect
//
//  Created by Putao0474 on 2022/7/11.
//

/*:
 算法: 加密__内部的字符串
 - 只有_ " 数字 字符串组成
 - 字符串连续__加密后只有一个_
 - ""成对出现, 可以是内部作为加密的字符串显示, 也可以表示空字符串
 - 没有加密返回"Error"
 
 例子1:
 saoaasda_ssa324223_timeout_100
 加密后: -> saoaasda_******_timeout_100
 
 例子2:
 2321_"sada43f3223"_timeout__100_""
 加密后: -> 2321_******_timeout_100_""
 */

import Foundation

/// k: 从下标N开始检索加密字符串
/// str: 需要检索加密的字符串
func secrect(_ k: Int, _ str: String ) -> String {
    let n = str.count
    guard k < n else { return "Error" }
    let prefix = [Character](str)[0..<k].map { String($0) }.joined()
    // 作为替换字符串
    var operate = [Character](str)[k..<n].map { String($0) }.joined()
    /// 先替换带有_"的表达式
    let reg1 = """
    [_]+["][a-z0-9]+["][_]+
    """
    /// 再替换带有_xxx_的表达式
    let reg2 = "[_]+[a-z0-9]+[_]+"
    let regs = [reg1, reg2]
    regs.forEach {
        while let range = operate.firstMatch($0) {
            operate
                .replaceSubrange(operate.index(operate.startIndex, offsetBy: range.location)..<operate.index(operate.startIndex, offsetBy: range.location + range.length),
                                 with: "+")
        }
    }
    guard operate.contains("+") else {
        return "Error"
    }
    return prefix + operate.replacingOccurrences(of: "+", with: "_******_")
}

extension String {
    
    func isMatch(_ reg: String) -> Bool {
        let p = NSPredicate(format: "SELF MATCHES %@", reg)
        return p.evaluate(with: self)
    }
    
    func firstMatch(_ pattern: String) -> NSRange? {
        guard let reg = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        let range = reg.rangeOfFirstMatch(in: self, range: NSRange(location: 0, length: self.count))
        if range.length == 0 {
            return nil
        }
        return range
    }
}

func testRegs() {
    let reg1 = """
    [_]+["][a-z0-9]+["][_]+
    """
    let reg2 = """
    [_]+[a-z0-9]+[_]+
    """
    var codes = """
    32asas_scasa121_8093jkdjio_dw
    """
    if let range = codes.firstMatch(reg2) {
        let start = codes.index(codes.startIndex, offsetBy: range.location)
        let ended = codes.index(codes.startIndex, offsetBy: range.location + range.length)
        codes.replaceSubrange(start..<ended, with: "+")
        print(codes)
    }

    let str1 = "dfss11erfre"
    if let reg = try? NSRegularExpression(pattern: "[1-9]", options: []) {
        print(reg.rangeOfFirstMatch(in: str1, range: NSRange(location: 0, length: str1.count)))
    }
}

// testRegs()

let str1 = "saoaasda_ssa324223_timeout_100"
let str2 = """
2321_"sada43f3223"_timeout__100_""
"""

print(secrect(10, str2))


