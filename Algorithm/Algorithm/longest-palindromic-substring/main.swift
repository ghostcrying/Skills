//
//  main.swift
//  longest-palindromic-substring
//
//  Created by 大大 on 2022/6/28.
//
/**
 给你一个字符串 s，找到 s 中最长的回文子串。

 示例 1：
 输入：s = "babad"
 输出："bab"
 解释："aba" 同样是符合题意的答案。
 
 示例 2：
 输入：s = "cbbd"
 输出："bb"
  
 提示：
 1 <= s.length <= 1000
 s 仅由数字和英文字母组成

 */

import Foundation

class Solution {
    
    // 中心扩散
    func longestPalindrome_1(_ s: String) -> String {
        if s.count < 2  {
            return s
        }
        
        let count = s.count
        let a = s.map({ String.init($0) })
        var maxStarts = 0, maxLength = 1
        // 记录左右节点
        var l = 0
        var r = 0
        // 单循环遍历
        for i in 0..<count {
            l = i-1
            r = i+1
            // 记录当前回文长度
            var len = 1
            // 右移
            while r < count && a[r] == a[i] {
                r += 1
                len += 1
            }
            // 左右双向移位
            while l >= 0 && r < count && a[r] == a[l] {
                // 此处l多走了一次, 所以需要最终l + 1, 得到真正的下标
                l -= 1
                r += 1
                len += 2
            }
                
            if len > maxLength {
                maxLength = len
                maxStarts = l
            }
        }
        return a[(maxStarts + 1)..<(maxStarts + maxLength + 1)].joined()
    }
    
    // 动态规划
    func longestPalindrome_2(_ s: String) -> String {
        guard s.count >= 2 else { return s }
        
        let count = s.count
        let a = s.map({ String($0)})
        var maxStarts = 0, maxLength = 1
        var methods = Array(repeating: Array(repeating: false, count: s.count), count: s.count)
                
        for r in 1..<count {
            for l in 0..<r {
                if a[l] == a[r] && (r - l <= 2 || methods[l + 1][r - 1]) {
                    methods[l][r] = true
                    if r - l + 1 > maxLength {
                        maxLength = r - l + 1
                        maxStarts = l
                    }
                }
            }
        }
        
        return a[maxStarts..<maxStarts+maxLength].joined()
    }
}

print(Solution().longestPalindrome_1("snckookcdd"))


