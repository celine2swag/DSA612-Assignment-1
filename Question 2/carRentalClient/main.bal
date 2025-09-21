
import ballerina/io;

public function main() returns error? {

    CarRentalClient carRentalClient = check new ("http://localhost:8080");
    
    io:println("=== Testing createUsers ===");
    CreateUsersStreamingClient streamingClient = check carRentalClient->createUsers();
    

    check streamingClient->sendUser({userName: "awike", role: "CUSTOMER"});
    check streamingClient->sendUser({userName: "admin", role: "ADMIN"});
    check streamingClient->complete();
    
    CreateUsersResponse? usersResponse = check streamingClient->receiveCreateUsersResponse();
    if usersResponse is CreateUsersResponse {
        io:println("Users created: ", usersResponse.message);
    }
    
    io:println("\n=== Testing addCar ===");
    AddCarRequest addCarReq = {
        car: {
            make: "Toyota",
            model: "Camry",
            year: 2023,
            plateNumber: "N67ND",
            price: 230000.0,
            kilos: 15000,
            status: "AVAILABLE"
        }
    };
    
    AddCarResponse addCarResp = check carRentalClient->addCar(addCarReq);
    io:println("Added car with plate: ", addCarResp.plate);
    
    AddCarRequest addCarReq2 = {
        car: {
            make: "Honda",
            model: "Civic",
            year: 2022,
            plateNumber: "N69T",
            price: 130000.0,
            kilos: 8000,
            status: "AVAILABLE"
        }
    };
    
    AddCarResponse addCarResp2 = check carRentalClient->addCar(addCarReq2);
    io:println("Added car with plate: ", addCarResp2.plate);
    
    io:println("\n=== Testing listAvailableCars ===");
    ListAllCarsRequest listReq = {filter: ""};
    ListAllCarsResponse listResp = check carRentalClient->listAvailableCars(listReq);
    io:println("Available cars count: ", listResp.cars.length());
    foreach Car car in listResp.cars {
        io:println("Car: ", car.make, " ", car.model, " (", car.plateNumber, ")");
    }
    
    io:println("\n=== Testing searchCar ===");
    SearchForCarRequest searchReq = {plateNumber: "N67ND"};
    SearchForCarResponse|error searchResp = carRentalClient->searchCar(searchReq);
    if searchResp is SearchForCarResponse {
        io:println("Found car: ", searchResp.car.make, " ", searchResp.car.model);
    } else {
        io:println("Search error: ", searchResp.message());
    }
    
    io:println("\n=== Testing addToCart ===");
    AddToCartRequest cartReq = {
        user: "awike",
        item: {
            plateNumber: "N67ND",
            startingDate: "2024-01-15",
            endingDate: "2024-01-20"
        }
    };
    
    AddToCartResponse cartResp = check carRentalClient->addToCart(cartReq);
    io:println("Cart response: ", cartResp.message);
    
    io:println("\n=== Testing placeReservation ===");
    PlaceReservationRequest reservationReq = {userName: "awike"};
    PlaceReservationResponse|error reservationResp = carRentalClient->placeReservation(reservationReq);
    if reservationResp is PlaceReservationResponse {
        io:println("Reservation: ", reservationResp.confirmation);
        io:println("Total price: $", reservationResp.totalPrice);
    } else {
        io:println("Reservation error: ", reservationResp.message());
    }
    
    io:println("\n=== Testing listAvailableCars after reservation ===");
    ListAllCarsResponse listResp2 = check carRentalClient->listAvailableCars(listReq);
    io:println("Available cars count after reservation: ", listResp2.cars.length());
    foreach Car car in listResp2.cars {
        io:println("Car: ", car.make, " ", car.model, " (", car.plateNumber, ") - Status: ", car.status);
    }
    
    io:println("\n=== All tests completed ===");
}

