//
//  main.swift
//  linked-list-cycle-ii
//
//  Created by 大大 on 2022/7/5.
//
/*:
 *LeetCode: 142. 环形链表 II
 *https://leetcode.cn/problems/linked-list-cycle-ii/
 
 给定一个链表的头节点  head ，返回链表开始入环的第一个节点。 如果链表无环，则返回 null。

 如果链表中有某个节点，可以通过连续跟踪 next 指针再次到达，则链表中存在环。 为了表示给定链表中的环，评测系统内部使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。如果 pos 是 -1，则在该链表中没有环。注意：pos 不作为参数进行传递，仅仅是为了标识链表的实际情况。
 不允许修改 链表。

  
 示例 1：
 https://assets.leetcode.com/uploads/2018/12/07/circularlinkedlist.png
 输入：head = [3,2,0,-4], pos = 1
 输出：返回索引为 1 的链表节点
 解释：链表中有一个环，其尾部连接到第二个节点。
 
 示例 2：
 https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test2.png
 输入：head = [1,2], pos = 0
 输出：返回索引为 0 的链表节点
 解释：链表中有一个环，其尾部连接到第一个节点。
 
 示例 3：
 https://assets.leetcode-cn.com/aliyun-lc-upload/uploads/2018/12/07/circularlinkedlist_test3.png
 输入：head = [1], pos = -1
 输出：返回 null
 解释：链表中没有环。
  

 提示：
 链表中节点的数目范围在范围 [0, 104] 内
 -105 <= Node.val <= 105
 pos 的值为 -1 或者链表中的一个有效索引
  

 进阶：你是否可以使用 O(1) 空间解决此题？

 */

import Foundation

public class ListNode {
    
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }

    public init() {
        self.val = 0
        self.next = nil
    }
    
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

extension ListNode: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        // 用于唯一标识
        hasher.combine(val)
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return lhs.next == rhs.next && lhs.val == rhs.val
    }
    
}

class Solution {
    // 通过Hash进行实现
    func detectCycle_1(_ head: ListNode?) -> ListNode? {
        var map = Set<ListNode>()
        var node = head
        while node != nil {
            if !map.insert(node!).inserted {
                return node
            }
            node = node?.next
        }
        return nil
    }
    // 公式推导
    func detectCycle_2(_ head: ListNode?) -> ListNode? {
        var slow: ListNode? = head
        var fast: ListNode? = head
        while fast != nil && fast?.next != nil {
            slow = slow?.next
            fast = fast?.next?.next
            // 环内相遇的点
            if slow == fast {
                // 环内相遇
                var list1: ListNode? = slow
                var list2: ListNode? = head
                while list1 != list2 {
                    list1 = list1?.next
                    list2 = list2?.next
                }
                return list2
            }
        }
        return nil
    }
    
    /// 删除链表的倒数第n个节点, 并返回头结点
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        var m = 0
        while head?.next != nil {
            m += 1
        }
        // 越界, 返回第一个, 被限定范围了不用处理
        // if n > m { return head }
        // m = 3 n = 2
        var space = m - n + 1
        let dummy = ListNode(0, head) // 虚节点
        var curr: ListNode? = dummy
        while space > 0 {
            space -= 1
            curr = curr?.next
        }
        // 此时node就是被删除节点的前一节点
        curr?.next = curr?.next?.next
        // 返回虚节点的下一节点
        return dummy.next
    }
}

