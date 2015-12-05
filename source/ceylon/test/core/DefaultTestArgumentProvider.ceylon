import ceylon.language.meta.declaration {
    ClassDeclaration,
    FunctionDeclaration,
    ValueDeclaration
}
import ceylon.test {
    TestArgumentProvider,
    DataProviderAnnotation
}
import ceylon.collection {
    LinkedList
}

"Provides arguments for test functions based on [[dataProvider|ceylon.test::dataProvider]] annotations."
shared class DefaultTestArgumentProvider() satisfies TestArgumentProvider {
    
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
            if (exists dataProviderAnnotation = parameterDeclaration.annotations<DataProviderAnnotation>().first) {
                "All possible arguments yielded by the data provider for the current parameter."
                Anything[] arguments;
                switch (provider = dataProviderAnnotation.provider)
                case (is FunctionDeclaration) { arguments = provider.apply<{Anything*},[]>()().sequence(); }
                case (is ValueDeclaration) { arguments = provider.apply<{Anything*}>().get().sequence(); }
                
                // append each yielded argument to every argument list we have so far
                LinkedList<EndList> newArgumentLists = LinkedList<EndList>();
                for (argumentList in argumentLists) {
                    for (argument in arguments) {
                        newArgumentLists.add(ConsEndList(argumentList, argument));
                    }
                }
                argumentLists = newArgumentLists;
            } else if (!parameterDeclaration.defaulted) {
                // can't provide argument for this parameter, bail out
                return [];
            }
        }
        
        return argumentLists.map((l) => l.sequence());
    }
    
    string => "DefaultTestArgumentProvider";
    equals(Object that) => that is DefaultTestArgumentProvider;
    hash => 31 * string.hash;
}
