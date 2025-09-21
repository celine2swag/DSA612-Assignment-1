import ballerina/grpc;
import CarRentalSystem.storage;

listener grpc:Listener grpcListener = new (8080);

@grpc:ServiceDescriptor {
    descriptor: CARRENTAL_DESC
}

service "CarRental" on grpcListener {
    
}
