
class Solution {
public:
    int numDecodings(string s) {
        int n = s.size();

        vector<int> dp(n + 1, 0);
        dp[0] = 1;

        for (int i = 1; i <= n; i++) {

            // Case 1: Decode one digit
            if (s[i - 1] != '0') {
                dp[i] += dp[i - 1];
            }

            // Case 2: Decode two digits
            if (i >= 2) {
                int twoDigits =
                    (s[i - 2] - '0') * 10
                    + (s[i - 1] - '0');

                if (twoDigits >= 10 && twoDigits <= 26) {
                    dp[i] += dp[i - 2];
                }
            }
        }

        return dp[n];
    }
};
