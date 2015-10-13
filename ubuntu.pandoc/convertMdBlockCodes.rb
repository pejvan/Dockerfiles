regex = /(^\s*$\n|\A)(^(?:[ ]{4}|\t).*[^\s].*$\n?(?:(?:^\s*$\n?)*^(?:[ ]{4}|\t).*[^\s].*$\n?)*)/;

data = File.read("CppCoreGuidelines.md");
result = data.gsub(regex) {
   ||
   x=$2;

   $1 + "```cpp\n" +   x.gsub(/^[ ]{1,4}/, '') + "```\n"
};

# Note - Tabs can be trimed too, use : x.gsub(/^(?:[ ]{1,4}|\t)/,'') in the above

length = File.write('CppCoreGuidelines-converted.md', result);

#print result;
print "Wrote #{length} characters";


