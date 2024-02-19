// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "../interface/IProduct.sol";
import "../library/ErrorMessage.sol";

contract ProductContract is IProduct {
    using ErrorMessage for *;

    mapping(uint => Product) public productMap;
    Product[] productList;
    uint productId;

    function createProduct(
        string memory _productName,
        string memory _productDescription,
        string memory _productImage,
        ProductStatus _productStatus
    ) external {
        uint idProduct = productId + 1;
        Product storage _newProduct = productMap[idProduct];
        _newProduct.id = idProduct;
        _newProduct.productName = _productName;
        _productDescription = _productDescription;
        _newProduct.productStatus = _productStatus;
        _newProduct.productImage = _productImage;

        productList.push(_newProduct);
        productId = productId + 1;
    }

    function upDateProduct(
        uint productId,
        string memory _productName,
        string memory _productDescription,
        ProductType _productDescription,
        string memory _productImage,
        ProductStatus _productStatus
    ) external {
        VALIDATE_PRODUCT_ID(productId);

        VALIDATE_PRODUCT_ID_MAP(productId);

        Product storage foundProduct = productMap[productId];
        foundProduct.productName = _productName;
        foundProduct.productDescription = _productDescription;
        foundProduct.productStatus = _productStatus;
        foundProduct.productImage = _productImage;
        updateProductInArray(foundProduct);
    }

    function updateProductInArray(Product storage updatedProduct) internal {
        for (uint i = 0; i < productList.length; i++) {
            if (productList[i].id == updatedProduct.id) {
                productList[i] = updatedProduct;
                break;
            }
        }
    }

    function getProductDetails(
        uint productId
    ) external returns (Product memory) {
        VALIDATE_PRODUCT_ID(productId);
        VALIDATE_PRODUCT_ID_MAP(productId);

        return productMap[productId];
    }

    function getProductList() external returns (Product[] memory) {
        return productList;
    }

    function VALIDATE_PRODUCT_ID_MAP(uint _productId) private {
        if (productMap[_productId].id == 0) {
            emit ErrorMessage.INVALID_PRODUCT_ID_MAP();
        }
    }

    function VALIDATE_PRODUCT_ID(uint productId) private {
        if (productId < 1 && productId > productList.length) {
            emit ErrorMessage.INVALID_PRODUCT_ID();
        }
    }
}
