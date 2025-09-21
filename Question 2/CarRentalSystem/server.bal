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

// Add To Cart
    remote function addToCart(AddToCartRequest req) returns AddToCartResponse|error {
        storage:CartItem item = {
            plateNumber: req.item.plateNumber,
            startingDate: req.item.startingDate,
            endingDate: req.item.endingDate
        };
        
        string message = storage:addToCart(req.user, item);
        return {message: message, item: req.item};
    }

remote function placeReservation(PlaceReservationRequest req) returns PlaceReservationResponse|error {
        var result = storage:placeReservation(req.userName);
        
        if(result is error){
            return error(result.message());
        }
        
        return {
            confirmation: result.confirmation,
            totalPrice: result.totalPrice 
        };
    }

//creating Users via Client Streaming
    remote function createUsers(stream<User, error?> clientStream) returns CreateUsersResponse|error {
        User[] newUsers = [];
        error? streamError = clientStream.forEach(function(User user) {
            newUsers.push(user);
        });
        
        if(streamError is error){
            return error("Error processing user stream: " + streamError.message());
        }
        
        // Converting the protobuf users to storage users
        storage:UserRecord[] storageUsers = [];
        foreach var user in newUsers {
            storageUsers.push({
                userName: user.userName,
                role: user.role
            });
        }
        
        string message = storage:createUsers(storageUsers);
        return {message: message};
    }
}
