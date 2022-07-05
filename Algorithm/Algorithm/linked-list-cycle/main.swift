//
//  main.swift
//  linked-list-cycle
//
//  Created by Putao0474 on 2022/7/5.
//
/*:
 ***LeetCode: 141. 环形链表
 *https://leetcode.cn/problems/linked-list-cycle/
 
 给你一个链表的头节点 head ，判断链表中是否有环。
 如果链表中有某个节点，可以通过连续跟踪 next 指针再次到达，则链表中存在环。 为了表示给定链表中的环，评测系统内部使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。注意：pos 不作为参数进行传递 。仅仅是为了标识链表的实际情况。

 如果链表中存在环 ，则返回 true 。 否则，返回 false 。

 示例 1：
 *https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist.png
 输入：head = [3,2,0,-4], pos = 1
 输出：true
 解释：链表中有一个环，其尾部连接到第二个节点。
 
 示例 2：
 *https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test2.png
 输入：head = [1,2], pos = 0
 输出：true
 解释：链表中有一个环，其尾部连接到第一个节点。
 
 示例 3：
 *https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test3.png
 输入：head = [1], pos = -1
 输出：false
 解释：链表中没有环。
  

 提示：
 链表中节点的数目范围是 [0, 104]
 -105 <= Node.val <= 105
 pos 为 -1 或者链表中的一个 有效索引 。

 */

import Foundation

public class ListNode {
    
    public var val: Int
    public init(_ val: Int) {
        self.val = val
    }
    
    public var next: ListNode?
    
}

extension ListNode: Equatable {
    static public func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.next == rhs.next && lhs.val == rhs.val
    }
}

class Solution {
    
    // 修改Node的val, 当有重复的就说明有环存在, 当然这样会破坏链表本身
    func hasCycle_1(_ head: ListNode?) -> Bool {
        if head?.next == nil {
            return false
        }
        
        var current = head
        while current?.next != nil {
            if current!.val == Int.min {
                return true
            }
            current?.val = Int.min
            current = current?.next
        }
        
        return false
        
    }
    
    func hasCycle_2(_ head: ListNode?) -> Bool {
        if head == nil || head?.next == nil {
            return false
        }
        var l: ListNode? = head
        var r: ListNode? = head?.next // 右指针比左指针跑的快一步
        while r != nil || l != nil {
            if l == r {
                return true
            }
            l = l?.next
            r = r?.next?.next
        }
        return false
    }
}

