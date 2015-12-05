import ceylon.language.meta.declaration {
    ...
}

"Marks a function as being a test.
 Test functions are usually nullary;
 otherwise, each parameter must specify a [[dataProvider]],
 or be defaulted.
 
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
    {Declaration+} sources) => TestSuiteAnnotation(sources);

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

"Specifies a data provider for a parameter.
 The data provider must be a toplevel value or nullary function
 returning a stream of values.
 `ceylon.test` then runs a test function once for each value that the data provider yields,
 passing it as the argument to the parameter annotated with that data provider.
 
 Example:
 
     shared {Integer*} intCornerCases => {
         0, 1, -1,
         2^16-1, 2^16,
         runtime.maxIntegerValue, runtime.minIntegerValue
     };
     
     test shared void intsShouldEqualThemselves(
         dataProvider (`value intCornerCases`) Integer int) {
         assertEquals(int, int);
     }
 
 This will run the `intsShouldEqualThemselves` test seven times,
 once for each integer in `intCornerCases`.
 
 A test function may have multiple parameters with data providers;
 it will be run for each combination of values from all data providers.
 That is, a function with one parameter whose data provider yields two values,
 and one parameter whose data provider yields three values,
 will be called six times.
 
 If a test function or data provider parameter does not specify a data provider,
 it must be defaulted, and `ceylon.test` will use the default argument.
"
shared annotation DataProviderAnnotation dataProvider(
    "Declaration of the data provider."
    FunctionOrValueDeclaration provider)
        => DataProviderAnnotation(provider);

"Annotation class for [[test]]."
shared final annotation class TestAnnotation()
        satisfies OptionalAnnotation<TestAnnotation,FunctionDeclaration> {}


"Annotation class for [[testSuite]]"
shared final annotation class TestSuiteAnnotation(
    "The program elements from which tests will be executed."
    shared {Declaration+} sources)
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

"Annotation class for [[dataProvider]]."
shared final annotation class DataProviderAnnotation(
    "Declaration of the data provider"
    shared FunctionOrValueDeclaration provider)
        satisfies OptionalAnnotation<DataProviderAnnotation,FunctionOrValueDeclaration> {}
