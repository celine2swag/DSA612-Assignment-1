import ballerina/io;
import ballerina/grpc;

public client class CarRentalClient {
    private grpc:Client grpcClient;
    
    public function init(string url) returns error? {
        self.grpcClient = check new(url);
    }
    
    remote function AddCar(Car car) returns CarResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/AddCar", car);
    }
    
    remote function UpdateCar(Car car) returns CarResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/UpdateCar", car);
    }
    
    remote function RemoveCar(CarRequest req) returns CarListResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/RemoveCar", req);
    }
    
    remote function ListAvailableCars(CarFilter filter) returns stream<Car, error?>|error {
        return self.grpcClient->executeServerStreaming("CarRental/ListAvailableCars", filter);
    }
    
    remote function SearchCar(CarRequest req) returns CarResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/SearchCar", req);
    }
    
    remote function AddToCart(CartItem item) returns CartResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/AddToCart", item);
    }
    
    remote function PlaceReservation(ReservationRequest req) returns ReservationResponse|error {
        return self.grpcClient->executeSimpleRPC("CarRental/PlaceReservation", req);
    }
}

public type Car record {
    string plate;
    string make;
    string model;
    int year;
    float dailyPrice;
    int mileage;
    string status;
};

public type CarRequest record {
    string plate;
};

public type CarFilter record {
    string filterText;
};

public type CarResponse record {
    string message;
    Car car?;
    boolean success;
};

public type CarListResponse record {
    string message;
    Car[] cars;
};

public type CartItem record {
    string customerId;
    string plate;
    string startDate;
    string endDate;
};

public type CartResponse record {
    string message;
    boolean success;
};

public type ReservationRequest record {
    string customerId;
};

public type ReservationResponse record {
    string message;
    float totalPrice;
    boolean success;
};

public function main() returns error? {
    CarRentalClient client = check new("http://localhost:9090");
    
    io:println("=== Car Rental System Demo ===\n");
    
    io:println("1. Adding a new car...");
    Car newCar = {
        plate: "N9999",
        make: "BMW",
        model: "X3",
        year: 2024,
        dailyPrice: 1200.0,
        mileage: 5000,
        status: "AVAILABLE"
    };
    
    CarResponse addResponse = check client->AddCar(newCar);
    io:println("Response: ", addResponse.message);
    io:println("Success: ", addResponse.success);
    io:println();
    
    io:println("2. Searching for car N1234...");
    CarRequest searchReq = { plate: "N1234" };
    CarResponse searchResponse = check client->SearchCar(searchReq);
    io:println("Response: ", searchResponse.message);
    if searchResponse.car is Car {
        Car foundCar = <Car>searchResponse.car;
        io:println("Found car: ", foundCar.make, " ", foundCar.model, " (", foundCar.year, ")");
        io:println("Daily Price: N$", foundCar.dailyPrice);
    }
    io:println();
    
    io:println("3. Listing available cars...");
    CarFilter filter = { filterText: "" };
    stream<Car, error?> carStream = check client->ListAvailableCars(filter);
    
    check carStream.forEach(function(Car car) {
        io:println("Available: ", car.plate, " - ", car.make, " ", car.model, " (N$", car.dailyPrice, "/day)");
    });
    io:println();
    
    io:println("4. Adding car to customer cart...");
    CartItem cartItem = {
        customerId: "CUST001",
        plate: "N1234",
        startDate: "2025-09-25",
        endDate: "2025-09-27"
    };
    
    CartResponse cartResponse = check client->AddToCart(cartItem);
    io:println("Response: ", cartResponse.message);
    io:println("Success: ", cartResponse.success);
    io:println();
    
    io:println("5. Placing reservation...");
    ReservationRequest reserveReq = { customerId: "CUST001" };
    ReservationResponse reserveResponse = check client->PlaceReservation(reserveReq);
    io:println("Response: ", reserveResponse.message);
    io:println("Total Price: N$", reserveResponse.totalPrice);
    io:println("Success: ", reserveResponse.success);
    io:println();
    
    io:println("6. Listing available cars after reservation...");
    stream<Car, error?> carStream2 = check client->ListAvailableCars({ filterText: "" });
    
    check carStream2.forEach(function(Car car) {
        io:println("Available: ", car.plate, " - ", car.make, " ", car.model, " (N$", car.dailyPrice, "/day)");
    });
    
    io:println("\n7. Updating car price...");
    Car updateCar = {
        plate: "N5678",
        make: "Honda",
        model: "Civic",
        year: 2023,
        dailyPrice: 650.0,
        mileage: 15000,
        status: "AVAILABLE"
    };
    
    CarResponse updateResponse = check client->UpdateCar(updateCar);
    io:println("Response: ", updateResponse.message);
    io:println();
    
    io:println("8. Removing car N9999...");
    CarRequest removeReq = { plate: "N9999" };
    CarListResponse removeResponse = check client->RemoveCar(removeReq);
    io:println("Response: ", removeResponse.message);
    io:println("Cars remaining: ", removeResponse.cars.length());
    
    io:println("\n=== Demo Complete ===");
}