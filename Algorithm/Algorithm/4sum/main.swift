//
//  main.swift
//  4sum
//
//  Created by Putao0474 on 2022/7/6.
//
/*
 ***LeetCode: 18. 四数之和
 *https://leetcode.cn/problems/4sum/
 
 给你一个由 n 个整数组成的数组 nums ，和一个目标值 target 。请你找出并返回满足下述全部条件且不重复的四元组 [nums[a], nums[b], nums[c], nums[d]] （若两个四元组元素一一对应，则认为两个四元组重复）：

 0 <= a, b, c, d < n
 a、b、c 和 d 互不相同
 nums[a] + nums[b] + nums[c] + nums[d] == target
 你可以按 任意顺序 返回答案 。

 示例 1：
 输入：nums = [1,0,-1,0,-2,2], target = 0
 输出：[[-2,-1,1,2], [-2,0,0,2], [-1,0,0,1]]
 
 示例 2：
 输入：nums = [2,2,2,2,2], target = 8
 输出：[[2,2,2,2]]
  
 提示：
 1 <= nums.length <= 200
 -109 <= nums[i] <= 109
 -109 <= target <= 109

 */

import Foundation

class Solution {
    
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        let n = nums.count
        if n < 4 { return [] }
        let lists = nums.sorted(by: <)
        // print(lists)
        var results = [[Int]]()
        for i in 0..<n-3 {
            // 相同元素跳过
            if i > 0 && lists[i - 1] == lists[i] {
                continue
            }
            let target2 = target - lists[i]
            // print(target2)
            // 从小到大: 因此最近的四元素和必须要小于target, 否则结束循环
            if lists[i + 1] + lists[i + 2] + lists[i + 3] > target2 {
                break
            }
            // 最后四个元素小于target, 则直接跳过
            if lists[n - 1] + lists[n - 2] + lists[n - 3] < target2 {
                continue
            }
            // 第二重循环
            for j in i+1..<n-2 {
                // 相同元素跳过
                if j > i + 1 && lists[j - 1] == lists[j] {
                    continue
                }
                // 从小到大: 因此最近的四元素和必须要小于target, 否则结束循环
                if lists[j] + lists[j + 1] + lists[j + 2] > target2 {
                    break
                }
                // 最后四个元素小于target, 则直接跳过
                if lists[j] + lists[n - 2] + lists[n - 1] < target2 {
                    continue
                }
                var l = j + 1, r = n - 1
                while l < r {
                    let s = lists[j] + lists[l] + lists[r]
                    if s == target2 {
                        // 符合条件
                        results.append([lists[i], lists[j], lists[l], lists[r]])
                        while l < r && lists[l] == lists[l + 1] {
                            l += 1
                        }
                        l += 1
                        while l < r && lists[r] == lists[r - 1] {
                            r -= 1
                        }
                        r -= 1
                    } else if s < target2 {
                        // 左指针右移
                        l += 1
                    } else {
                        // 右指针左移
                        r -= 1
                    }
                }
            }
        }
        return results
    }
}


print(Solution().fourSum([1,0,-1,0,-2,2], 0))
