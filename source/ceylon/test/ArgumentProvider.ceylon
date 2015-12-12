import ceylon.language.meta.declaration {
    FunctionOrValueDeclaration
}

"Represents a strategy to provide arguments for test function parameters.
 For every test function parameter, the argument provider may return an arbitrary number of arguments,
 which are then used by the [[ArgumentListProvider]] in use to construct argument lists.
 (Not all `ArgumentsProvider`s use `ArgumentProvider`s.)"
shared interface ArgumentProvider {
    "Determine the arguments for the given test function parameter."
    shared formal {Anything*} arguments(FunctionOrValueDeclaration parameter);
}
