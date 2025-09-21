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

// Implemented a listAvailableCars function that lists all available cars in the inventory
public function listAvailableCars(string filter) returns CarRecord[]|string {
    CarRecord[] availableCars = [];
    
    if(cars.length() == 0){
        return "There are currently no cars in the inventory!!!";
    }
    
    foreach CarRecord car in cars{
        if(car.status == "AVAILABLE"){
            if(filter == "" || car.make.includes(filter) || car.model.includes(filter) ||  car.year.toString().includes(filter)){
                availableCars.push(car);
            }
        }
    }
    
    if(availableCars.length() == 0){
        return "No available cars found";
    }
    
    return availableCars;
}
//    return availableCars
public function searchCar(string plate) returns CarRecord|string {
    CarRecord? returnedCar = cars[plate];
    if(returnedCar is ()){
        return "Car with that plate does not exist";
    }
    return returnedCar;
}

// Function to create multiple users at once
public function createUsers(UserRecord[] newUsers) returns string {
    foreach var user in newUsers {
        users[user.userName] = user;
    }

    return newUsers.length().toString() + " users created successfully";
}

// Function to add a car to a user's cart
public function addToCart(string username, CartItem item) returns string {
    if(!users.hasKey(username)){
        return "User with username " + username + " does not exist!!!";
    }

    CarRecord? foundCar = cars[item.plateNumber];
    if(foundCar is ()){
        return "Car does not exist";
    }
    

    CarRecord car = foundCar;
    if(car.status != "AVAILABLE"){
        return "That car is currently not available";
    }
    
    int|error days = calculateDays(item.startingDate, item.endingDate);
    if(days is error){
        return "Invalid dates provided";
    }
    
    CartItem[] existingCart = carts[username] ?: [];
    existingCart.push(item);
    carts[username] = existingCart; 
    
    return "Car with plate number " + item.plateNumber + " has been added to your cart successfully!!!";
}

//Places a reservation for a user
//return - Reservation response or error
public function placeReservation(string username) returns record {|
    string confirmation;
    float totalPrice;
|}|error {
    if(!users.hasKey(username)){
        return error("No user with that username exists in our database!!!");
    }
    
    //CartItem[] items = carts[username];
    CartItem[] items = carts[username] ?: [];
    if(items.length() == 0){
        return error("Your cart is empty");
    }
    
    float total = 0.0;
    
    foreach CartItem item in items {
        CarRecord? carOpt = cars[item.plateNumber];
        if(carOpt is ()){
            return error("Car with plate " + item.plateNumber + " does not exist!!!");
        }
        
        CarRecord car = carOpt;
        if(car.status != "AVAILABLE"){
            return error("Car with plate " + item.plateNumber + " is not available!!!");
        }
        
        int|error daysResult = calculateDays(item.startingDate, item.endingDate);
        if(daysResult is error){
            return error("Invalid date entered for car " + item.plateNumber + "!!!");
        }
        
        int days = daysResult;
        total += days * car.price;
        
        // Mark car as unavailable
        car.status = "UNAVAILABLE";
        cars[item.plateNumber] = car;
    }
    
    // Create reservation
    ReservationRecord reservation = {
        userName: username,
        items: items,
        totalPrice: total,
        status: "CONFIRMED"
    };
    reservations.push(reservation);
    
    // Clear cart
    _ = carts.remove(username);
    
    return {
        confirmation: "Reservation confirmed for " + username,
        totalPrice: total
    };
}


// Helper function to calculate the number of days between two dates
function calculateDays(string startDateStr, string endDateStr) returns int|error {
    [int, decimal]|error startDate = time:utcFromString(startDateStr + "T00:00:00Z");
    [int, decimal]|error endDate = time:utcFromString(endDateStr + "T00:00:00Z");
    
    if startDate is error || endDate is error {
        return error("Invalid date format");
    }
    
    [int, decimal]|error startTuple=startDate;
    [int, decimal]|error endTuple = endDate;

    if(startTuple is error){
        return error("Invalid starting Date");
    }
    if(endTuple is error){
        return error("Invalid ending date");
    }

    int startSec = startTuple[0];
    int endSec = endTuple[0];
    
    int diffSeconds = endSec-startSec;
    if diffSeconds < 0 {
        return error("End date must be after start date");
    }
    
    int days = (diffSeconds / 86400) + 1;
    return days;
}
