//
//  main.swift
//  longest-substring-without-repeating-characters
//
//  Created by Putao0474 on 2022/6/29.
//
/**
 *** LeetCode: 3. 无重复字符的最长子串
 * https://leetcode.cn/problems/longest-substring-without-repeating-characters/
 给定一个字符串 s ，请你找出其中不含有重复字符的 最长子串 的长度。

 示例 1:
 输入: s = "abcabcbb"
 输出: 3
 解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
 
 示例 2:
 输入: s = "bbbbb"
 输出: 1
 解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
 
 示例 3:
 输入: s = "pwwkew"
 输出: 3
 解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
      请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。
  
 提示：
 0 <= s.length <= 5 * 104
 s 由英文字母、数字、符号和空格组成
 
 */

import Foundation

class Solution {
    // 滑动窗口
    func lengthOfLongestSubstring_1(_ s: String) -> Int {
        if s.count < 2 { return s.count }
        
        let chs = Array<Character>(s)
        var map = [Character: Int]()
        var start = 0
        var maxLength = 1
        for i in 0..<chs.count {
            let c = chs[i]
            if let preIndex = map[c] {
                start = max(preIndex + 1, start)
            }
            maxLength = max(maxLength, i - start + 1)
            map[c] = i
        }
        return maxLength
    }
    // Hash优化: Asscii数组
    func lengthOfLongestSubstring_2(_ s: String) -> Int {
        if s.count < 2 { return s.count }
        
        let chs = Array<Character>(s)
        var map = Array(repeating: -1, count: 128)
        var start = 0
        var maxLength = 1
        for i in 0..<chs.count {
            let index = Int(chs[i].asciiValue ?? 0)
            start = max(map[index] + 1, start)
            maxLength = max(maxLength, i - start + 1)
            map[index] = i
        }
        return maxLength
    }

}

// print("Hello, World!")

