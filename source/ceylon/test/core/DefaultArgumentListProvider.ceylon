import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration
}
import ceylon.test {
    ArgumentProvider,
    ArgumentListProvider
}
import ceylon.collection {
    ArrayList,
    LinkedList
}

"Provides argument lists for test functions based on annotations that satisfy [[ArgumentProvider]]."
shared class DefaultArgumentListProvider() satisfies ArgumentListProvider {
    
    "An immutable, unparameterized list type that supports exactly one operation efficiently:
     obtaining a new list by appending one element at the *end*."
    abstract class EndList()
            extends Object()
            satisfies List<Anything> {}
    object emptyEndList extends EndList() {
        lastIndex => null;
        getFromFirst(Integer index) => null;
    }
    class ConsEndList(EndList remainder, Anything end) extends EndList() {
        shared actual Integer lastIndex = remainder.lastIndex?.plus(1) else 0;
        shared actual Anything? getFromFirst(Integer index) {
            switch (index <=> lastIndex)
            case (smaller) { return remainder.getFromFirst(index); }
            case (equal) { return end; }
            case (larger) { return null; }
        }
    }
    
    shared actual default {Anything[]*} argumentLists(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration) {
        "All argument lists."
        variable LinkedList<EndList> argumentLists = LinkedList { emptyEndList };
        
        for (parameterDeclaration in functionDeclaration.parameterDeclarations) {
            "All possible arguments yielded by all argument providers for the current parameter."
            ArrayList<Anything> arguments = ArrayList<Anything>();
            for (argumentProvider in parameterDeclaration.annotations<Annotation>().narrow<ArgumentProvider>()) {
                arguments.addAll(argumentProvider.arguments(parameterDeclaration));
            }
            if (arguments.empty) {
                if (parameterDeclaration.defaulted) {
                    // done
                    break;
                } else {
                    // can't provide argument for this parameter, bail out
                    return [];
                }
            }
            // append each yielded argument to every argument list we have so far
            LinkedList<EndList> newArgumentLists = LinkedList<EndList>();
            for (argumentList in argumentLists) {
                for (argument in arguments) {
                    newArgumentLists.add(ConsEndList(argumentList, argument));
                }
            }
            argumentLists = newArgumentLists;
        }
        
        return argumentLists.map((l) => l.sequence());
    }
    
    string => "DefaultArgumentListProvider";
    equals(Object that) => that is DefaultArgumentListProvider;
    hash => 31 * string.hash;
}
