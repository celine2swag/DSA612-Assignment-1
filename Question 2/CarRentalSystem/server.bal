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

remote function removeCar(RemoveCarRequest req) returns RemoveCarResponse|error {
    var result = storage:removeCar(req.plate);
    
    if(result is string){
        return {message: result, cars: []};
    } else {
        Car[] pbCars = [];
        foreach var car in result {
            pbCars.push({
                make: car.make,
                model: car.model,
                year: car.year,
                plateNumber: car.plateNumber,
                price: car.price, 
                kilos: car.kilos,
                status: car.status
            });
        }
        return {message: "Car removed successfully", cars: pbCars};
    }
}

remote function listAvailableCars(ListAllCarsRequest req) returns ListAllCarsResponse|error {
    var result = storage:listAvailableCars(req.filter);
    
    if(result is string){
        return {cars: []};
    } else {
        Car[] pbCars = [];
        foreach var car in result {
            pbCars.push({
                make: car.make,
                model: car.model,
                year: car.year,
                plateNumber: car.plateNumber,
                price: car.price,
                kilos: car.kilos,
                status: car.status
            });
        }
        return {cars: pbCars};
    }
}

remote function searchCar(SearchForCarRequest req) returns SearchForCarResponse|error {
        var result = storage:searchCar(req.plateNumber);
        
        if(result is string){
            return error("Car not found: " + result);
        } else {
            Car pbCar = {
                make: result.make,
                model: result.model,
                year: result.year,
                plateNumber: result.plateNumber,
                price: result.price, 
                kilos: result.kilos,
                status: result.status
            };
            return {car: pbCar};
        }
    }

}
