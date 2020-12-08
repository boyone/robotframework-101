# Tag

[http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id498](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#id498)

    1.1.1   Why Robot Framework?
    - Provides [tagging](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#tagging-test-cases) to categorize and [select test cases](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#selecting-test-cases) to be executed.

## In this section it is only explained how to set tags for test cases, and different ways to do it are listed below. These approaches can naturally be used together.

1. Force Tags in the Setting table  
   All test cases in a test case file with this setting always get specified tags. If it is used in the test suite initialization file, all test cases in sub test suites get these tags.
2. Default Tags in the Setting table  
   Test cases that do not have a [Tags] setting of their own get these tags. Default tags are not supported in test suite initialization files.
3. [Tags] in the Test Case table  
   A test case always gets these tags. Additionally, it does not get the possible tags specified with Default Tags, so it is possible to override the Default Tags by using empty value. It is also possible to use value NONE to override default tags.
4. --settag command line option  
   All executed test cases get tags set with this option in addition to tags they got elsewhere.
5. Set Tags, Remove Tags, Fail and Pass Execution keywords  
   These BuiltIn keywords can be used to manipulate tags dynamically during the test execution.

```robot
*** Settings ***
Force Tags      req-42
Default Tags    owner-john    smoke

*** Variables ***
${HOST}         10.0.1.42

*** Test Cases ***
No own tags
    [Documentation]    This test has tags owner-john, smoke and req-42.
    No Operation

With own tags
    [Documentation]    This test has tags not_ready, owner-mrx and req-42.
    [Tags]    owner-mrx    not_ready
    No Operation

Own tags with variables
    [Documentation]    This test has tags host-10.0.1.42 and req-42.
    [Tags]    host-${HOST}
    No Operation

Empty own tags
    [Documentation]    This test has only tag req-42.
    [Tags]
    No Operation

Set Tags and Remove Tags Keywords
    [Documentation]    This test has tags mytag and owner-john.
    Set Tags    mytag
    Remove Tags    smoke    req-*
```

## 3.5.2 Selecting test cases

### By tag names

It is possible to include and exclude test cases by tag names with the --include (-i) and --exclude (-e) options, respectively. If the --include option is used, only test cases having a matching tag are selected, and with the --exclude option test cases having a matching tag are not. If both are used, only tests with a tag matching the former option, and not with a tag matching the latter, are selected.

```sh
--include example
--exclude not_ready
--include regression --exclude long_lasting
```

Both --include and --exclude can be used several times to match multiple tags. In that case a test is selected if it has a tag that matches any included tags, and also has no tag that matches any excluded tags.

In addition to specifying a tag to match fully, it is possible to use tag patterns where \* and ? are wildcards and AND, OR, and NOT operators can be used for combining individual tags or patterns together:

```sh
--include feature-4?
--exclude bug*
--include fooANDbar
--exclude xxORyyORzz
--include fooNOTbar
```

Selecting test cases by tags is a very flexible mechanism and allows many interesting possibilities:  

- A subset of tests to be executed before other tests, often called smoke tests, can be tagged with smoke and executed with --include smoke.
- Unfinished test can be committed to version control with a tag such as not_ready and excluded from the test execution with --exclude not_ready.
- Tests can be tagged with sprint-<num>, where <num> specifies the number of the current sprint, and after executing all test cases, a separate report containing only the tests for a certain sprint can be generated (for example, rebot --include sprint-42 output.xml).
