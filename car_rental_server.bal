import ballerina/grpc;
import ballerina/log;
import ballerina/time;

// --- Helpers ---
function parseDateToDays(string d) returns int|error {
    string[] parts =string[] parts = d.split("-");
    if parts.length() != 3 {
        return error("invalid-date-format");
    }
    int year = check int:fromString(parts[0]);
    int month = check int:fromString(parts[1]);
    int day = check int:fromString(parts[2]);

    int y = year;
    int m = month;
    if m <= 2 {
        y -= 1;
        m += 12;
    }
    int a = y / 100;
    int b = a / 4;
    int c = 2 - a + b;
    int days = <int>(365.25 * (y + 4716)) +
               <int>(30.6001 * (m + 1)) +
               day + c - 1524;
    return days;
}

function daysBetween(string startDate, string endDate) returns int|error {
    int s = check parseDateToDays(startDate);
    int e = check parseDateToDays(endDate);
    int diff = e - s + 1;
    if diff <= 0 {
        return error("end-before-start");
    }
    return diff;
}

function rangesOverlap(string s1, string e1, string s2, string e2) returns boolean|error {
    int a1 = check parseDateToDays(s1);
    int b1 = check parseDateToDays(e1);
    int a2 = check parseDateToDays(s2);
    int b2 = check parseDateToDays(e2);
    return (a1.max(a2)) <= (b1.min(b2));
}

// --- Data Types ---
type Car record {
    string plate;
    string make;
    string model;
    int year;
    float daily_price;
    int mileage;
    string status; 
};

type User record {
    string id;
    string name;
    string email;
    boolean is_admin;
};

type CartEntry record {
    string plate;
    string start_date;
    string end_date;
};

type Reservation record {
    string reservation_id;
    string user_id;
    CartEntry[] items;
    float total_price;
};

// Placeholder request types
type UpdateCarRequest record {};
type AvailableFilter record { string text?; };
type CartItem record {
    string user_id;
    string plate;
    string start_date;
    string end_date;
};
type SearchCarRequest record { string plate; };

// --- Service ---
listener grpc:Listener carListener = new (9090);

service /carrental on carListener {

    map<Car> cars = {};
    map<User> users = {};
    map<CartEntry[]> carts = {};
    map<Reservation[]> reservations = {};

    remote function AddCar(Car request) returns map<any> {
        if self.cars.hasKey(request.plate) {
            return { ok: false, message: "car already exists" };
        }
        self.cars[request.plate] = request;
        log:printInfo("Added car: " + request.plate);
        return { ok: true, message: "car added" };
    }

    remote function CreateUsers(stream<User, error?> clientStream) returns map<any>|error {
        int count = 0;
        string[] created = [];
        while true {
            var res = clientStream.next();
            if res is User {
                self.users[res.id] = res;
                created.push(res.id);
                count += 1;
            } else {
                break;
            }
        }
        return { created_count: count, created_ids: created };
    }

    remote function UpdateCar(UpdateCarRequest request) returns map<any> {
        return { ok: true, message: "update car (demo only)" };
    }

    remote function AddToCart(CartItem req) returns map<any> {
        if !self.users.hasKey(req.user_id) {
            return { ok: false, message: "user not found" };
        }
        if !self.cars.hasKey(req.plate) {
            return { ok: false, message: "car not found" };
        }
        CartEntry entry = { plate: req.plate, start_date: req.start_date, end_date: req.end_date };
        if !self.carts.hasKey(req.user_id) {
            self.carts[req.user_id] = [];
        }
        CartEntry[] cart = self.carts[req.user_id] ?: [];
        cart.push(entry);
        self.carts[req.user_id] = cart;
        return { ok: true, message: "added to cart" };
    }

    remote function PlaceReservation(User req) returns map<any> {
        if !self.carts.hasKey(req.id) || self.carts[req.id] is () || (self.carts[req.id] ?: []).length() == 0 {
            return { ok: false, message: "cart empty" };
        }
        string resId = "res-" + req.id + "-" + time:utcNow().toString();
        CartEntry[] items = self.carts[req.id] ?: [];
        Reservation r = { reservation_id: resId, user_id: req.id, items: items, total_price: 100.0 };
        if !self.reservations.hasKey(req.id) {
            self.reservations[req.id] = [];
        }
        Reservation[] resArr = self.reservations[req.id] ?: [];
        resArr.push(r);
        self.reservations[req.id] = resArr;
        var _ = self.carts.remove(req.id);
        return { ok: true, message: "reservation placed", reservation_id: resId };
    }

    remote function RemoveCar(Car request) returns map<any> {
        if !self.cars.hasKey(request.plate) {
            return { ok: false, message: "car not found" };
        }
        var _ = self.cars.remove(request.plate);
        return { ok: true, message: "car removed" };
    }

    remote function ListAvailableCars(AvailableFilter req) returns stream<Car, error?>|error {
    Car[] availableCars = [];
    foreach var [_, c] in self.cars.entries() {
        if c.status == "AVAILABLE" {
            availableCars.push(c);
        }
    }
    return availableCars.toStream();
}


    remote function SearchCar(SearchCarRequest req) returns map<any> {
        if !self.cars.hasKey(req.plate) {
            return { found: false, message: "not found" };
        }
        return { found: true, car: self.cars[req.plate] };
    }

}

public function main() returns error? {
    log:printInfo(" Car Rental gRPC server running on port 9090");
}
