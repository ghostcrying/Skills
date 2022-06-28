//
//  main.swift
//  longest-common-prefix
//
//  Created by 大大 on 2022/6/28.
//

/**
 编写一个函数来查找字符串数组中的最长公共前缀。
 如果不存在公共前缀，返回空字符串 ""。

 示例 1：
 输入：strs = ["flower", "flow", "flight"]
 输出："fl"
 
 示例 2：
 输入：strs = ["dog", "racecar", "car"]
 输出：""
 解释：输入不存在公共前缀。
  
 提示：
 1 <= strs.length <= 200
 0 <= strs[i].length <= 200
 strs[i] 仅由小写英文字母组成
 */
import Foundation


class Solution {
    
    func longestCommonPrefix_1(_ strs: [String]) -> String {
        if strs.count < 2 {
            return strs.joined()
        }
        var strs = strs.sorted { $0.count < $1.count }
        var index = strs[0].count
        while index > 0 {
            for i in 0..<strs.count {
                strs[i] = String(strs[i].prefix(index))
            }
            if Set(strs).count == 1 {
                return strs[0]
            }
            index -= 1
        }
        return ""
    }
    
    // 分治法
    func longestCommonPrefix_2(_ strs: [String]) -> String {
        if strs.count < 2 {
            return strs.joined()
        }
        return findLongestCommonPrefix(strs, 0, strs.count - 1)
    }
    
    private func findLongestCommonPrefix(_ strs: [String], _ start: Int, _ ended: Int) -> String {
        if start >= ended {
            return strs[start]
        }
        let mid = (start + ended) / 2
        let left = findLongestCommonPrefix(strs, 0, mid - 1)
        let right = findLongestCommonPrefix(strs, mid, ended)
        return commonPrefix(left, right)
    }

    private func commonPrefix(_ leftStr: String, _ rightStr: String) -> String {
        if leftStr.count <= 0 || rightStr.count <= 0 {
            return ""
        }
        let array_l = Array(leftStr)
        let array_r = Array(rightStr)
        let minCount = min(array_l.count, array_r.count)
        for i in 0..<minCount {
            if array_l[i] != array_r[i] {
                return String(leftStr.prefix(i))
            }
        }
        return String(leftStr.prefix(minCount))
    }
}



// print("Hello, World!")

