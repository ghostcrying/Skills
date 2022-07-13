//
//  main.swift
//  Algorithm
//
//  Created by 大大 on 2022/6/28.
//
/*:
 * 常用基础排序
 **/
import Foundation

func buddleSort(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var lists = nums
    for i in 0..<n {
        for j in 0..<n-i-1 {
            if lists[j] > lists[j + 1] {
                lists.swapAt(j, j+1)
            }
        }
    }
    return lists
}

// 选择最新的值放到已排序数组合适位置
func insertSort(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var lists = nums
    for i in 1..<n {
        let temp = lists[i]
        var j = i
        while j > 0 && lists[j - 1] < temp {
            lists[j] = lists[j - 1]
            j -= 1
        }
        lists[j] = temp
    }
    return lists
}

// 二分插入排序
func insertBinSort(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var lists = nums
    for i in 1..<n {
        let temp = lists[i]
        var l = 0, r = i - 1, m = 0
        while l <= r {
            m = (l + r) / 2
            if lists[m] > temp {
                r = m - 1
            } else {
                l = m + 1
            }
        }
        for j in stride(from: i - 1, through: l, by: -1) {
            lists[j + 1] = lists[j]
        }
        lists[l] = temp
    }
    return lists
}

// 选择右边最值放在已排序数组末尾
func selectSort(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var lists = nums
    for i in 0..<n-1 {
        var low = i
        for j in i+1..<n {
            if lists[j] < lists[low] {
                low = j
            }
        }
        if low != i {
            lists.swapAt(i, low)
        }
    }
    return lists
}

func quickSort(_ nums: [Int]) -> [Int] {
    guard nums.count > 1 else { return nums }
    let mid = nums[nums.count / 2]
    let less = nums.filter { $0 < mid }
    let equal = nums.filter { $0 == mid }
    let large = nums.filter { $0 > mid }
    return quickSort(less) + equal + quickSort(large)
}

// 希尔排序
func shellSort(_ nums: [Int]) -> [Int] {

    // 对指定区域数组排序
    func insertSort(_ nums: inout [Int], _ l: Int, _ gap: Int) {
        let n = nums.count
        for i in stride(from: l + gap, to: n, by: gap) {
            let temp = nums[i]
            var j = i
            while j >= gap && nums[j - gap] > temp {
                nums[j] = nums[j - gap]
                j -= gap
            }
            nums[j] = temp
        }
    }

    var lists = nums
    var gap = nums.count / 2
    while gap > 0 {
        for p in 0..<gap {
            insertSort(&lists, p, gap)
        }
        gap = gap / 2
    }
    return lists
}


var lists = [6, 10, 5, 100, 5, 4, 3, 9, 20]
print(insertBinSort(lists))
print(shellSort(lists))


/// 实现约瑟夫环(公式: 数学递推推导出来)
/// m个人围成一个圈，指定一个数字n,从第一个人开始报数，每轮报到n的选手出局，由下一个人接着从头开始报，最后一个人是赢家。其中m>1,n>2。
func Josephus(_ m: Int, out: Int) -> Int {
    var temp = 0
    for i in 1...m {
        temp = (temp + out) % i // // f[i] = (f[i-1] + m) % i
    }
    return temp
}
