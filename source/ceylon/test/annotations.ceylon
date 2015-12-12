import ceylon.language.meta.declaration {
    ...
}
import ceylon.test.core {
    DefaultArgumentListProvider
}

"Marks a function as being a test.
 Test functions are usually nullary;
 otherwise, each parameter must specify an [[argumentProvider]] or be defaulted,
 or the test function must specify an [[argumentListProvider]].
 
 Example of simplest test:
 
     test
     shared void shouldAlwaysSucceed() {}
"
shared annotation TestAnnotation test() => TestAnnotation();

"Annotation to specify test suite, which allow combine several tests or test suites and run them together.
 
     testSuite({`class YodaTest`,
                `class DarthVaderTest`,
                `function starOfDeathTestSuite`})
     shared void starwarsTestSuite() {}
"
shared annotation TestSuiteAnnotation testSuite(
    "The program elements from which tests will be executed."
    {Declaration+} sources,
    "The argument list provider for all tests in this test suite."
    ClassWithInitializerDeclaration argumentListProvider/* = `class DefaultArgumentListProvider`*/) => TestSuiteAnnotation(sources, argumentListProvider);

"Annotation to specify custom [[TestExecutor]] implementation, which will be used for running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, the most closest will be used.
 
      testExecutor(`class ArquillianTestExecutor`)
      package com.acme;
"
shared annotation TestExecutorAnnotation testExecutor(
    "The class declaration of [[TestExecutor]]."
    ClassDeclaration executor) => TestExecutorAnnotation(executor);

"Annotation to specify custom [[TestListener]]s, which will be used during running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, all listeners will be used.
 
     testListeners({`class DependencyInjectionTestListener`,
                    `class TransactionalTestListener`})
     package com.acme;
"
shared annotation TestListenersAnnotation testListeners(
    "The class declarations of [[TestListener]]s"
    {ClassDeclaration+} listeners) => TestListenersAnnotation(listeners);

"Marks a function which will be run before each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `beforeTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
"
shared annotation BeforeTestAnnotation beforeTest() => BeforeTestAnnotation();

"Marks a function which will be run after each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `afterTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
 "
shared annotation AfterTestAnnotation afterTest() => AfterTestAnnotation();

"Marks a test or group of tests which should not be executed, which will be skipped during test run.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 
     test
     ignore(\"still not implemented\")
     void shouldBeFasterThanLight() {
 
"
shared annotation IgnoreAnnotation ignore(
    "Reason why the test is ignored."
    String reason = "") => IgnoreAnnotation(reason);

"Specifies an argument provider for a parameter.
 The argument provider must be a toplevel value or nullary function
 returning a stream of values (arguments).
 `ceylon.test`'s [[DefaultArgumentListProvider]] then runs a test function once for each value that the data provider yields,
 passing it as the argument to the parameter annotated with that data provider.
 (Custom [[ArgumentListProvider]] implementations may ignore this annotation.)
 
 Example:
 
     shared {Integer*} intCornerCases => {
         0, 1, -1,
         2^16-1, 2^16,
         runtime.maxIntegerValue, runtime.minIntegerValue
     };
     
     test shared void intsShouldEqualThemselves(
         argumentProvider (`value intCornerCases`) Integer int) {
         assertEquals(int, int);
     }
 
 This will run the `intsShouldEqualThemselves` test seven times,
 once for each integer in `intCornerCases`.
 
 A test function may have multiple parameters with argument providers;
 it will be run for each combination of values from all data providers.
 That is, a function with one parameter whose argument provider yields two values,
 and one parameter whose argument provider yields three values,
 will be called six times.
 
 If a test function parameter does not specify an argument provider,
 it must be defaulted, and `ceylon.test` will use the default argument.
"
shared annotation ArgumentProviderAnnotation argumentProvider(
    "Declaration of the argument provider."
    FunctionOrValueDeclaration provider)
        => ArgumentProviderAnnotation(provider);

"Specifies an argument list provider for a test function or suite.
 The argument list provider is a class satisArgumentListProviderProvider]]
 that is instantiated once (must have nullary initializer parameters)
 and then called for each test function,
 yielding a stream of argument lists.
 The test function is then called once with each argument list.
 
 Example:
 
     shared class PlusMinusArgumentsProvider() satisfies ArgumentListProvider {
         shared actual {Anything[]*} argumentLists(FunctionDeclaration fd, ClassDeclaration? cd)
                 => { [1,-1], [2,-2], [0,0] };
     }
     
     test
     argumentListProvider (`class PlusMinusArgumentsProvider`)
     shared void plusMinus(Integer i1, Integer i2)
             => assertEquals(i1,-i2);
 
 This will run the `plusMinus` test three times."
shared annotation ArgumentListProviderAnnotation argumentListProvider(
    "Declaration of the argument list provider class."
    ClassWithInitializerDeclaration provider)
        => ArgumentListProviderAnnotation(provider);

"Annotation class for [[test]]."
shared final annotation class TestAnnotation()
        satisfies OptionalAnnotation<TestAnnotation,FunctionDeclaration> {}


"Annotation class for [[testSuite]]"
shared final annotation class TestSuiteAnnotation(
    "The program elements from which tests will be executed."
    shared {Declaration+} sources,
    "The argument list provider for all tests in this test suite."
    shared ClassWithInitializerDeclaration argumentListProvider)
        satisfies OptionalAnnotation<TestSuiteAnnotation,FunctionDeclaration> {}


"Annotation class for [[testExecutor]]."
shared final annotation class TestExecutorAnnotation(
    "The class declaration of [[TestExecutor]]."
    shared ClassDeclaration executor)
        satisfies OptionalAnnotation<TestExecutorAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[testListeners]]."
shared final annotation class TestListenersAnnotation(
    "The class declarations of [[TestListener]]s"
    shared {ClassDeclaration+} listeners)
        satisfies OptionalAnnotation<TestListenersAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[beforeTest]]."
shared final annotation class BeforeTestAnnotation()
        satisfies OptionalAnnotation<BeforeTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[afterTest]]."
shared final annotation class AfterTestAnnotation()
        satisfies OptionalAnnotation<AfterTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ignore]]."
shared final annotation class IgnoreAnnotation(
    "Reason why the test is ignored."
    shared String reason)
        satisfies OptionalAnnotation<IgnoreAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> & TestCondition {
    
    shared actual Result evaluate(TestDescription description) => Result(false, reason);
    
}

"Annotation class for [[argumentProvider]]."
shared final annotation class ArgumentProviderAnnotation(
    "Declaration of the argument provider"
    shared FunctionOrValueDeclaration provider)
        satisfies OptionalAnnotation<ArgumentProviderAnnotation,FunctionOrValueDeclaration> & ArgumentProvider {
    shared actual {Anything*} arguments(FunctionOrValueDeclaration parameter) {
        switch (provider)
        case (is FunctionDeclaration) { return provider.apply<{Anything*},[]>()(); }
        case (is ValueDeclaration) { return provider.apply<{Anything*}>().get(); }
    }
}

"Annotation class for [[argumentListProvider]]."
shared final annotation class ArgumentListProviderAnnotation(
    "Declaration of the argument list provider class"
    shared ClassWithInitializerDeclaration provider)
        satisfies OptionalAnnotation<ArgumentListProviderAnnotation, FunctionDeclaration> {}
