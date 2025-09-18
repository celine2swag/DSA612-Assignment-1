Car Rental gRPC Server
This Ballerina program implements a simple car rental backend over gRPC.
Features:
//Manage cars (add, remove, search, list available)
//Manage users (create single/bulk)
//Add cars to a user's cart with date ranges
//Place reservations (convert cart items into confirmed bookings)
//Uses in-memory storage (maps) for cars, users, carts, and reservations
//Includes helper functions for working with dates (parse, compare, overlap)
//Runs on port 9090 and logs server activity.

NOTE:i keep running into one error cause im using an old version of ballerina so yall probaly have the newer version and see if the code works
the error is located in line 7 |string[] parts = d.split("-");| . 
