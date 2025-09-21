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
