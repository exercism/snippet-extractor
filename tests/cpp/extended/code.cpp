#if !defined(TWO_FER_H)
#define TWO_FER_H

#include <string>

using namespace std;

namespace two_fer
{
    /* multiline comments
    can have comments 
    // single line commennt
    or include #something 
    */
    inline string two_fer(const string& name = "you")
    {
        // There might be a comment here
        return "One for " + name + ", one for me."; // A comment after a valid line 
    }
} // namespace two_fer

#endif //TWO_FER_H
