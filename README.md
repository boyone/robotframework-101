# Robot Framework 101

## Prerequisite

1. [Python3](https://www.python.org/downloads/)
2. [Robot Framework](https://robotframework.org/)

   ```sh
   pip install robotframework
   ```

3. [User Guide](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)

---

## Basic Syntax

### Structure

- Settings
  - [Library](https://robotframework.org/#examples)
- Variables
- [Test Cases](https://robotframework.org/#examples)
- Tasks
- [Keywords](https://robotframework.org/#examples)
- [Keywords](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#creating-user-keywords)
  Keyword tables are used to create new higher-level keywords by combining existing keywords together. These keywords are called `user keywords` to differentiate them from lowest level `library keywords` that are implemented in test libraries.

- [Report And Log](https://robotframework.org/#examples)

### Variables

- Scalar
- List
- Dictionary
- Environment

### Tagging

### Command Line Options

- variables + command line parameters
  - local http, remote https
- tags + command line options

### Execution Flow

- Suite Setup
- Test Template
- Test Setup
- Test Teardown
- Suite Teardown

## Standard Library

- [Collections](http://robotframework.org/robotframework/latest/libraries/Collections.html)
- [XML](http://robotframework.org/robotframework/latest/libraries/XML.html)

## Extending Robot Framework

## External Library

- [HTTP RequestsLibrary (Python)](/requestsLibrary/README.md)

- [DateTime](http://robotframework.org/robotframework/latest/libraries/DateTime.html)
- [Faker](https://pypi.org/project/robotframework-faker/)
  - [Example](https://github.com/laurentbristiel/robotframework-faker-example)
- [DataDriver](https://github.com/Snooz82/robotframework-datadriver)

## PyPi

The Python Package Index ([PyPI](https://pypi.org/)) is a repository of software for the Python programming language.

## pip

[pip](https://pypi.org/project/pip/) is the package installer for Python

## Creating Virtual Environments

Python “[Virtual Environments](https://packaging.python.org/tutorials/installing-packages/#creating-virtual-environments)” allow Python packages to be installed in an isolated location for a particular application, rather than being installed globally.

### 2 common tools for creating Python virtual environments:

1. [venv](https://docs.python.org/3/library/venv.html) is available by default in Python 3.3 and later, and installs pip and setuptools into created virtual environments in Python 3.4 and later.
   Using `venv`

   ```sh
   python3 -m venv <DIR>
   source <DIR>/bin/activate
   ```

2. [virtualenv](https://packaging.python.org/key_projects/#virtualenv) needs to be installed separately, but supports Python 2.7+ and Python 3.3+, and pip, setuptools and wheel are always installed into created virtual environments by default (regardless of Python version).
   Using `virtualenv`:

   ```sh
   virtualenv <DIR>
   source <DIR>/bin/activate
   ```

## Todo

[x] slice in Python3
[ ] [Inline Python evaluation](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#inline-python-evaluation)
[ ] [Variable priorities and scopes](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#variable-priorities-and-scopes)
