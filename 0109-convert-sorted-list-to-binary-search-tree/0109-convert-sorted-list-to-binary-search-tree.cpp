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
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    ListNode* current;

    TreeNode* build(int left, int right) {
        if (left > right) {
            return nullptr;
        }

        int mid = left + (right - left) / 2;

        TreeNode* leftSubtree = build(left, mid - 1);

        TreeNode* root = new TreeNode(current->val);
        current = current->next;

        root->left = leftSubtree;
        root->right = build(mid + 1, right);

        return root;
    }

    TreeNode* sortedListToBST(ListNode* head) {
        int length = 0;
        ListNode* temp = head;

        while (temp != nullptr) {
            length++;
            temp = temp->next;
        }

        current = head;
        return build(0, length - 1);
    }
};
