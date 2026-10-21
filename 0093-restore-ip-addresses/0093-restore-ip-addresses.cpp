
class Solution {
public:
    vector<string> result;

    void backtrack(string& s, int index, int parts,
                   string& current) {
        if (parts == 4) {
            if (index == s.size()) {
                result.push_back(current);
            }
            return;
        }

        int remaining = s.size() - index;

        // Prune impossible choices
        if (remaining < 4 - parts ||
            remaining > 3 * (4 - parts)) {
            return;
        }

        int value = 0;
        int oldSize = current.size();

        for (int len = 1; len <= 3 && index + len <= s.size(); len++) {
            // Leading zero: only "0" is allowed
            if (len > 1 && s[index] == '0') {
                break;
            }

            value = value * 10 + (s[index + len - 1] - '0');

            if (value > 255) {
                break;
            }

            if (parts > 0) {
                current.push_back('.');
            }

            current.append(s, index, len);

            backtrack(s, index + len, parts + 1, current);

            current.resize(oldSize);
        }
    }

    vector<string> restoreIpAddresses(string s) {
        result.clear();

        if (s.size() < 4 || s.size() > 12) {
            return result;
        }

        string current;
        backtrack(s, 0, 0, current);

        return result;
    }
};
