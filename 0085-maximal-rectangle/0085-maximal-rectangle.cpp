class Solution {
public:

    int largestRectangleArea(vector<int>& heights) {

        stack<int> st;
        int maxArea = 0;

        heights.push_back(0);

        for (int i = 0; i < heights.size(); i++) {

            while (!st.empty() &&
                   heights[i] < heights[st.top()]) {

                int height = heights[st.top()];
                st.pop();

                int width;

                if (st.empty()) {
                    width = i;
                } else {
                    width = i - st.top() - 1;
                }

                int area = height * width;

                maxArea = max(maxArea, area);
            }

            st.push(i);
        }

        heights.pop_back();

        return maxArea;
    }


    int maximalRectangle(vector<vector<char>>& matrix) {

        if (matrix.empty()) {
            return 0;
        }

        int rows = matrix.size();
        int cols = matrix[0].size();

        vector<int> heights(cols, 0);

        int answer = 0;

        for (int row = 0; row < rows; row++) {

            for (int col = 0; col < cols; col++) {

                if (matrix[row][col] == '1') {
                    heights[col]++;
                } else {
                    heights[col] = 0;
                }
            }

            answer = max(answer, largestRectangleArea(heights));
        }

        return answer;
    }
};