class Solution {
public:
    int removeDuplicates(vector<int>& nums) {

        int left = 0;

        for (int right = 0; right < nums.size(); right++) {

            // First two elements are always allowed
            // OR current element is different from
            // the element two positions before
            if (left < 2 || nums[right] != nums[left - 2]) {

                nums[left] = nums[right];

                left++;
            }
        }

        return left;
    }
};