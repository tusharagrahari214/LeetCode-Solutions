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
    ListNode* partition(ListNode* head, int x) {

        ListNode* lessDummy = new ListNode(0);
        ListNode* greaterDummy = new ListNode(0);

        ListNode* lessTail = lessDummy;
        ListNode* greaterTail = greaterDummy;

        ListNode* current = head;

        while (current != nullptr) {

            if (current->val < x) {

                lessTail->next = current;
                lessTail = lessTail->next;

            } else {

                greaterTail->next = current;
                greaterTail = greaterTail->next;
            }

            current = current->next;
        }

        greaterTail->next = nullptr;

        lessTail->next = greaterDummy->next;

        return lessDummy->next;
    }
};