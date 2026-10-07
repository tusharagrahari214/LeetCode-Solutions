class Solution {
public:

    unordered_map<string, bool> memo;

    bool solve(string s1, string s2) {

        string key = s1 + "#" + s2;

        // Already calculated?
        if (memo.find(key) != memo.end()) {
            return memo[key];
        }

        // Same strings
        if (s1 == s2) {
            return memo[key] = true;
        }

        // Different lengths
        if (s1.size() != s2.size()) {
            return memo[key] = false;
        }

        // Same characters?
        string a = s1;
        string b = s2;

        sort(a.begin(), a.end());
        sort(b.begin(), b.end());

        if (a != b) {
            return memo[key] = false;
        }

        int n = s1.size();

        for (int i = 1; i < n; i++) {

            // Case 1: No Swap
            if (solve(s1.substr(0, i),
                      s2.substr(0, i)) &&
                solve(s1.substr(i),
                      s2.substr(i))) {

                return memo[key] = true;
            }

            // Case 2: Swap
            if (solve(s1.substr(0, i),
                      s2.substr(n - i)) &&
                solve(s1.substr(i),
                      s2.substr(0, n - i))) {

                return memo[key] = true;
            }
        }

        return memo[key] = false;
    }


    bool isScramble(string s1, string s2) {

        memo.clear();

        return solve(s1, s2);
    }
};