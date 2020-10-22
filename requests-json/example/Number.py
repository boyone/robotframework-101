from robot.api.deco import keyword

ROBOT_AUTO_KEYWORDS = False

@keyword
def add(l, r):
    return l + r

@keyword
def hello(name):
    print("Hello, %s!" % name)