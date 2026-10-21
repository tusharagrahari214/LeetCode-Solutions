
class Solution {
public:
    vector<string> result;

    bool valid(string part) {
        if (part.size() > 1 && part[0] == '0') {
            return false;
        }

        int num = stoi(part);

        return num >= 0 && num <= 255;
    }

    void backtrack(string& s, int index,
                   int parts, string current) {

        if (parts == 4) {
            if (index == s.size()) {
                current.pop_back(); // Remove last dot
                result.push_back(current);
            }
            return;
        }

        for (int len = 1; len <= 3; len++) {
            if (index + len > s.size()) {
                break;
            }

            string part = s.substr(index, len);

            if (valid(part)) {
                backtrack(s, index + len, parts + 1,
                          current + part + ".");
            }
        }
    }

    vector<string> restoreIpAddresses(string s) {
        result.clear();

        if (s.size() < 4 || s.size() > 12) {
            return result;
        }

        backtrack(s, 0, 0, "");

        return result;
    }
};
