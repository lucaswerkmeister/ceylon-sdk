import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration
}

"Represents a strategy to provide argument lists for tests.
 For every test function, the argument list provider may return an arbitrary number of argument lists,
 and the test function is executed once with each argument list returned.
 (If the argument list provider returns no argument lists, the test fails.)"
shared interface ArgumentListProvider {
    "Determine the argument lists for the given test function."
    shared formal {Anything[]*} argumentLists(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration);
}
