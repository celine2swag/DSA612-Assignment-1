import ballerina/time;
public type CarRecord record {|
    string make;
    string model;
    int year;
    string plateNumber;
    float price;
    int kilos;
    string status;
|};

public type UserRecord record {|
    string userName;
    string role;
|};

public type CartItem record {|
    string plateNumber;
    string startingDate;
    string endingDate;
|};

public type ReservationRecord record {|
    string userName;
    CartItem[] items;
    float totalPrice;
    string status;
|};

public map<CarRecord> cars = {};
public map<UserRecord> users = {};
public map<CartItem[]> carts = {};
public ReservationRecord[] reservations = [];

public function addCar(CarRecord car) returns string {
    if(cars.hasKey(car.plateNumber)){
        return "Car with that plate number exists!!!";
    }
    cars[car.plateNumber] = car;
    return car.plateNumber;
}

public function updateCar(CarRecord car) returns string {
    if(!cars.hasKey(car.plateNumber)){
        return "Car with plate number " + car.plateNumber + " does not exist!!!";
    }
    cars[car.plateNumber] = car;
    return "Car with plate number " + car.plateNumber + " updated successfully!!!";
}

public function removeCar(string plate) returns string|CarRecord[] {
    if(!cars.hasKey(plate)){
        return "That car does not exist";
    }
    CarRecord removedCar;
    removedCar = cars.remove(plate);
    
    CarRecord[] remainingCars = [];
    foreach CarRecord car in cars{
        remainingCars.push(car);
    }
    
    return remainingCars;
}
