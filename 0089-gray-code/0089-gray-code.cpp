class Solution {
public:
    vector<int> grayCode(int n) {
        vector<int> result = {0};

        for (int i = 0; i < n; i++) {
            int add = 1 << i;

            for (int j = result.size() - 1; j >= 0; j--) {
                result.push_back(result[j] + add);
            }
        }

        return result;
    }
};