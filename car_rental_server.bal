import ballerina/grpc;
import ballerina/io;
import ballerina/time;

public type Car record {
    string plate;
    string make;
    string model;
    int year;
    float dailyPrice;
    int mileage;
    string status;
};

public type User record {
    string userId;
    string name;
    string role;
};

public type CartItem record {
    string customerId;
    string plate;
    string startDate;
    string endDate;
};

public type Reservation record {
    string customerId;
    string plate;
    string startDate;
    string endDate;
    float totalPrice;
};

map<Car> carDB = {};
map<User> userDB = {};
map<CartItem[]> customerCarts = {};
Reservation[] reservations = [];

service "CarRental" on new grpc:Listener(9090) {

    remote function AddCar(Car car) returns CarResponse {
        if carDB.hasKey(car.plate) {
            return {
                message: "Car with plate " + car.plate + " already exists",
                car: car,
                success: false
            };
        }
        
        car.status = "AVAILABLE";
        carDB[car.plate] = car;
        
        return {
            message: "Car added successfully with plate: " + car.plate,
            car: car,
            success: true
        };
    }

    remote function UpdateCar(Car car) returns CarResponse {
        if !carDB.hasKey(car.plate) {
            return {
                message: "Car not found",
                success: false
            };
        }
        
        carDB[car.plate] = car;
        return {
            message: "Car updated successfully",
            car: car,
            success: true
        };
    }

    remote function RemoveCar(CarRequest req) returns CarListResponse {
        if !carDB.hasKey(req.plate) {
            return {
                message: "Car not found",
                cars: carDB.values().cloneReadOnly()
            };
        }
        
        _ = carDB.remove(req.plate);
        return {
            message: "Car removed successfully",
            cars: carDB.values().cloneReadOnly()
        };
    }

    remote function ListAvailableCars(CarFilter filter) returns stream<Car, error?> {
        Car[] availableCars = [];
        
        foreach Car car in carDB.values() {
            if car.status == "AVAILABLE" {
                if filter.filterText == "" || 
                   car.make.toLowerAscii().includes(filter.filterText.toLowerAscii()) ||
                   car.year.toString().includes(filter.filterText) {
                    availableCars.push(car);
                }
            }
        }
        
        return availableCars.toStream();
    }

    remote function SearchCar(CarRequest req) returns CarResponse {
        if !carDB.hasKey(req.plate) {
            return {
                message: "Car not found",
                success: false
            };
        }
        
        Car car = carDB[req.plate];
        if car.status != "AVAILABLE" {
            return {
                message: "Car is not available",
                car: car,
                success: false
            };
        }
        
        return {
            message: "Car found and available",
            car: car,
            success: true
        };
    }

    remote function AddToCart(CartItem item) returns CartResponse {
        if !carDB.hasKey(item.plate) {
            return {
                message: "Car not found",
                success: false
            };
        }
        
        Car car = carDB[item.plate];
        if car.status != "AVAILABLE" {
            return {
                message: "Car is not available",
                success: false
            };
        }
        
        if customerCarts.hasKey(item.customerId) {
            customerCarts[item.customerId].push(item);
        } else {
            customerCarts[item.customerId] = [item];
        }
        
        return {
            message: "Car added to cart for dates " + item.startDate + " to " + item.endDate,
            success: true
        };
    }

    remote function PlaceReservation(ReservationRequest req) returns ReservationResponse {
        if !customerCarts.hasKey(req.customerId) || customerCarts[req.customerId].length() == 0 {
            return {
                message: "No items in cart",
                totalPrice: 0.0,
                success: false
            };
        }
        
        CartItem[] cart = customerCarts[req.customerId];
        float totalPrice = 0.0;
        
        foreach CartItem item in cart {
            if !carDB.hasKey(item.plate) {
                return {
                    message: "Car " + item.plate + " no longer exists",
                    totalPrice: 0.0,
                    success: false
                };
            }
            
            Car car = carDB[item.plate];
            if car.status != "AVAILABLE" {
                return {
                    message: "Car " + item.plate + " is no longer available",
                    totalPrice: 0.0,
                    success: false
                };
            }
            
            int days = 1;
            float price = <float>days * car.dailyPrice;
            totalPrice += price;
            
            Reservation reservation = {
                customerId: req.customerId,
                plate: item.plate,
                startDate: item.startDate,
                endDate: item.endDate,
                totalPrice: price
            };
            reservations.push(reservation);
            
            car.status = "UNAVAILABLE";
            carDB[item.plate] = car;
        }
        
        customerCarts[req.customerId] = [];
        
        return {
            message: "Reservation placed successfully",
            totalPrice: totalPrice,
            success: true
        };
    }

    remote function CreateUsers(stream<User, error?> userStream) returns UserResponse {
        int userCount = 0;
        
        error? e = userStream.forEach(function(User user) {
            userDB[user.userId] = user;
            userCount += 1;
        });
        
        if e is error {
            return {
                message: "Error creating users: " + e.message(),
                usersCreated: userCount
            };
        }
        
        return {
            message: "Successfully created " + userCount.toString() + " users",
            usersCreated: userCount
        };
    }
}

public function main() returns error? {
    io:println("Car Rental gRPC Server started on port 9090");
    
    Car sampleCar = {
        plate: "N1234",
        make: "Toyota",
        model: "Corolla",
        year: 2022,
        dailyPrice: 500.0,
        mileage: 25000,
        status: "AVAILABLE"
    };
    carDB[sampleCar.plate] = sampleCar;
    
    Car sampleCar2 = {
        plate: "N5678",
        make: "Honda",
        model: "Civic",
        year: 2023,
        dailyPrice: 600.0,
        mileage: 15000,
        status: "AVAILABLE"
    };
    carDB[sampleCar2.plate] = sampleCar2;
    
    io:println("Sample cars added to database");
}