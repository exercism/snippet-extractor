#include <string>

namespace two_fer
{
    std::string two_fer(const std::string& name = "you")
    {
        return "One for " + name + ", one for me.";
    }
}
