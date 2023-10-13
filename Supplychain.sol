// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain {
    address public owner;
    
    enum State { Created, InTransit, Delivered }
    
    struct Product {
        string name;
        uint256 price;
        address manufacturer;
        State state;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    event ProductCreated(uint256 productId, string name, uint256 price, address manufacturer);
    event ProductShipped(uint256 productId);
    event ProductDelivered(uint256 productId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProduct(string memory _name, uint256 _price) public onlyOwner {
        productCount++;
        products[productCount] = Product({
            name: _name,
            price: _price,
            manufacturer: msg.sender,
            state: State.Created
        });

        emit ProductCreated(productCount, _name, _price, msg.sender);
    }

    function shipProduct(uint256 _productId) public onlyOwner {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        require(products[_productId].state == State.Created, "Product is not in a creatd state");

        products[_productId].state = State.InTransit;
        emit ProductShipped(_productId);
    }

    function deliverProduct(uint256 _productId) public onlyOwner {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        require(products[_productId].state == State.InTransit, "Product is not in transit");

        products[_productId].state = State.Delivered;
        emit ProductDelivered(_productId);
    }
}
