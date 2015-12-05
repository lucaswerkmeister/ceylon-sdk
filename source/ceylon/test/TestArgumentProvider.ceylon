import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration
}

"Represents a strategy to provide arguments for tests.
 For every test function, the argument provider may return an arbitrary number of argument lists,
 and the test function is executed once with each argument list returned.
 (If the argument provider returns no argument lists, the test fails.)"
shared interface TestArgumentProvider {
    "Determine the argument lists for the given test function."
    shared formal {Anything[]*} argumentLists(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration);
}
