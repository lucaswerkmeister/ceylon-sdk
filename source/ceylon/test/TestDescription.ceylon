import ceylon.language.meta.declaration {
    ...
}

"Describes a test, or a group of tests, can be arranged in a tree."
shared class TestDescription(name, functionDeclaration = null, classDeclaration = null, argumentList = null, children = []) {
    
    "The user friendly name of this test."
    shared String name;
    
    "The function declaration of this test, if one exists."
    shared FunctionDeclaration? functionDeclaration;
    
    "The class declaration, which is container of this test, if one exists."
    shared ClassDeclaration? classDeclaration;
    
    "The argument list of this test,
     or [[null]] if this is not a single test."
    shared Anything[]? argumentList;
    
    "The children of this test, if any."
    shared TestDescription[] children;
    
    shared actual Boolean equals(Object that) {
        if (is TestDescription that) {
            return name == that.name
                    && equalsCompare(functionDeclaration, that.functionDeclaration)
                    && equalsCompare(classDeclaration, that.classDeclaration)
                    && equalsCompare(argumentList, that.argumentList)
                    && children == that.children;
        }
        return false;
    }
    
    shared actual Integer hash => name.hash;
    
    shared actual String string => name;
}
