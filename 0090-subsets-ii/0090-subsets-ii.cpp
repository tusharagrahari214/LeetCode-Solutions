
class Solution {
public:
    vector<vector<int>> result;
    vector<int> current;

    void backtrack(vector<int>& nums, int start) {
        result.push_back(current);

        for (int i = start; i < nums.size(); i++) {
            if (i > start && nums[i] == nums[i - 1]) {
                continue;
            }

            current.push_back(nums[i]);

            backtrack(nums, i + 1);

            current.pop_back();
        }
    }

    vector<vector<int>> subsetsWithDup(vector<int>& nums) {
        sort(nums.begin(), nums.end());

        result.clear();
        current.clear();

        backtrack(nums, 0);

        return result;
    }
};
