// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract GarageManager{

    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    function addCar(
        string memory _make,
        string memory _model,
        string memory _color,
        uint _nDoors
    ) public {
        Car memory newCar = Car(_make, _model, _color, _nDoors);
        garage[msg.sender].push(newCar);
    }

    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    function getUserCars(address _address) public view returns (Car[] memory) {
        return garage[_address];
    }

    function updateCar(
        uint _idx,
        string memory _make,
        string memory _model,
        string memory _color,
        uint _nDoors
    ) public {
        require(_idx < garage[msg.sender].length, "Index error!");
        Car storage oldCar = garage[msg.sender][_idx];
        oldCar.make = _make;
        oldCar.model = _model;
        oldCar.color = _color;
        oldCar.numberOfDoors = _nDoors;
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }

}
