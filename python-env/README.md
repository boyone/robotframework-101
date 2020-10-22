# Readme

## Create Python virtual Environment Name "env"

### Python2

```sh
pip install virtualenv
```

```sh
virtualenv env
```

### Python3 [venv](https://docs.python.org/3/tutorial/venv.html)

```sh
python3 -m venv env
```

## Activate

### Python3

```sh
# Unix or MacOS
source env/bin/activate
```

```sh
# Windows
env\Scripts\activate.bat
```

### Python2

```sh
# Unix or MacOS
source env/Scripts/activate
```

```sh
# Windows
env\Scripts\activate.bat
```

## deactivate

```sh
# Unix or MacOS and Windows
deactivate
```

## check

```sh
which python
echo $PATH
```

## default site-package

### Python3

```sh
ls env/lib/python3.7/site-packages
```

### Python2

```sh
ls env/Lib/site-packages
```

## install package

```sh
pip install pymongo pytz requests elasticsearch
```

## List packages and Write to file

```sh
pip freeze > requirements.txt
```

## Deactivate and Remove env directory

```sh
deactivate
rm -rf env
```

## Create virtual environment and install packages after clone project

### Python3

```sh
python3 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

### Python2

```sh
python -m venv env
source env/Scripts/activate
pip install -r requirements.txt
```