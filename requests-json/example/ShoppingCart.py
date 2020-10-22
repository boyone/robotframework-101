from robot.api.deco import keyword

ROBOT_AUTO_KEYWORDS = False

@keyword
def find_product_by_name(products, name):
    for product in products:
        if product['product_name'] == name:
            return product
    raise ValueError("Product not found")