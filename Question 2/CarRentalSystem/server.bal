import ballerina/grpc;
import CarRentalSystem.storage;

listener grpc:Listener grpcListener = new (8080);

@grpc:ServiceDescriptor {
    descriptor: CARRENTAL_DESC
}

service "CarRental" on grpcListener {

remote function addCar(AddCarRequest req) returns AddCarResponse|error {
    storage:CarRecord car = {
        make: req.car.make,
        model: req.car.model,
        year: req.car.year,
        plateNumber: req.car.plateNumber,
        price: req.car.price, 
        kilos: req.car.kilos,
        status: req.car.status
    };
    
    string plate = storage:addCar(car);
    return {plate: plate};
}

remote function updateCar(UpdateCarRequest req) returns UpdateCarResponse|error {
    storage:CarRecord car = {
        make: req.car.make,
        model: req.car.model,
        year: req.car.year,
        plateNumber: req.car.plateNumber,
        price: req.car.price, 
        kilos: req.car.kilos,
        status: req.car.status
    };
    
    string message = storage:updateCar(car);
    return {message: message};
}



}
