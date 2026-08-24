/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */

class Solution {
public:
    ListNode* deleteDuplicates(ListNode* head) {

        ListNode* dummy = new ListNode(0);
        dummy->next = head;

        ListNode* prev = dummy;
        ListNode* current = head;

        while (current != nullptr) {

            // Check if current value is duplicated
            if (current->next != nullptr &&
                current->val == current->next->val) {

                // Skip all nodes having the same value
                while (current->next != nullptr &&
                       current->val == current->next->val) {

                    current = current->next;
                }

                // Remove the entire duplicate group
                prev->next = current->next;

            }
            else {

                // Current node is unique
                prev = prev->next;
            }

            current = current->next;
        }

        return dummy->next;
    }
};