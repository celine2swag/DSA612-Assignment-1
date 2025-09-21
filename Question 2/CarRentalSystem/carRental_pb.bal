import ballerina/grpc;
import ballerina/protobuf;

public const string CARRENTAL_DESC = "0A1570726F746F2F63617252656E74616C2E70726F746F120963617272656E74616C22A9010A0343617212120A046D616B6518012001280952046D616B6512140A056D6F64656C18022001280952056D6F64656C12120A047965617218032001280552047965617212200A0B706C6174654E756D626572180420012809520B706C6174654E756D62657212140A0570726963651805200128015205707269636512140A056B696C6F7318062001280552056B696C6F7312160A06737461747573180720012809520673746174757322360A0455736572121A0A08757365724E616D651801200128095208757365724E616D6512120A04726F6C651802200128095204726F6C6522720A0A4974656D496E4361727412200A0B706C6174654E756D626572180120012809520B706C6174654E756D62657212220A0C7374617274696E6744617465180220012809520C7374617274696E6744617465121E0A0A656E64696E6744617465180320012809520A656E64696E6744617465228E010A0B5265736572766174696F6E121A0A08757365724E616D651801200128095208757365724E616D65122B0A056974656D7318022003280B32152E63617272656E74616C2E4974656D496E4361727452056974656D73121E0A0A746F74616C5072696365180320012801520A746F74616C507269636512160A06737461747573180420012809520673746174757322310A0D4164644361725265717565737412200A0363617218012001280B320E2E63617272656E74616C2E436172520363617222260A0E416464436172526573706F6E736512140A05706C6174651801200128095205706C61746522340A105570646174654361725265717565737412200A0363617218012001280B320E2E63617272656E74616C2E4361725203636172222D0A11557064617465436172526573706F6E736512180A076D65737361676518012001280952076D65737361676522280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522510A1152656D6F7665436172526573706F6E736512180A076D65737361676518012001280952076D65737361676512220A046361727318022003280B320E2E63617272656E74616C2E436172520463617273222C0A124C697374416C6C436172735265717565737412160A0666696C746572180120012809520666696C74657222390A134C697374416C6C43617273526573706F6E736512220A046361727318012003280B320E2E63617272656E74616C2E43617252046361727322370A13536561726368466F724361725265717565737412200A0B706C6174654E756D626572180120012809520B706C6174654E756D62657222380A14536561726368466F72436172526573706F6E736512200A0363617218012001280B320E2E63617272656E74616C2E436172520363617222510A10416464546F436172745265717565737412290A046974656D18012001280B32152E63617272656E74616C2E4974656D496E4361727452046974656D12120A047573657218022001280952047573657222580A11416464546F43617274526573706F6E736512180A076D65737361676518012001280952076D65737361676512290A046974656D18022001280B32152E63617272656E74616C2E4974656D496E4361727452046974656D22350A17506C6163655265736572766174696F6E52657175657374121A0A08757365724E616D651801200128095208757365724E616D65225E0A18506C6163655265736572766174696F6E526573706F6E736512220A0C636F6E6669726D6174696F6E180120012809520C636F6E6669726D6174696F6E121E0A0A746F74616C5072696365180220012801520A746F74616C5072696365222F0A134372656174655573657273526573706F6E736512180A076D65737361676518012001280952076D65737361676532E3040A0943617252656E74616C123D0A0661646443617212182E63617272656E74616C2E416464436172526571756573741A192E63617272656E74616C2E416464436172526573706F6E736512400A0B6372656174655573657273120F2E63617272656E74616C2E557365721A1E2E63617272656E74616C2E4372656174655573657273526573706F6E7365280112460A09757064617465436172121B2E63617272656E74616C2E557064617465436172526571756573741A1C2E63617272656E74616C2E557064617465436172526573706F6E736512460A0972656D6F7665436172121B2E63617272656E74616C2E52656D6F7665436172526571756573741A1C2E63617272656E74616C2E52656D6F7665436172526573706F6E736512520A116C697374417661696C61626C6543617273121D2E63617272656E74616C2E4C697374416C6C43617273526571756573741A1E2E63617272656E74616C2E4C697374416C6C43617273526573706F6E7365124C0A09736561726368436172121E2E63617272656E74616C2E536561726368466F72436172526571756573741A1F2E63617272656E74616C2E536561726368466F72436172526573706F6E736512460A09616464546F43617274121B2E63617272656E74616C2E416464546F43617274526571756573741A1C2E63617272656E74616C2E416464546F43617274526573706F6E7365125B0A10706C6163655265736572766174696F6E12222E63617272656E74616C2E506C6163655265736572766174696F6E526571756573741A232E63617272656E74616C2E506C6163655265736572766174696F6E526573706F6E7365620670726F746F33";

public isolated client class CarRentalClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CARRENTAL_DESC);
    }

    isolated remote function addCar(AddCarRequest|ContextAddCarRequest req) returns AddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/addCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarResponse>result;
    }

    isolated remote function addCarContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/addCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarResponse>result, headers: respHeaders};
    }

    isolated remote function updateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/updateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarResponse>result;
    }

    isolated remote function updateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/updateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarResponse>result, headers: respHeaders};
    }

    isolated remote function removeCar(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/removeCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarResponse>result;
    }

    isolated remote function removeCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/removeCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarResponse>result, headers: respHeaders};
    }

    isolated remote function listAvailableCars(ListAllCarsRequest|ContextListAllCarsRequest req) returns ListAllCarsResponse|grpc:Error {
        map<string|string[]> headers = {};
        ListAllCarsRequest message;
        if req is ContextListAllCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/listAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ListAllCarsResponse>result;
    }

    isolated remote function listAvailableCarsContext(ListAllCarsRequest|ContextListAllCarsRequest req) returns ContextListAllCarsResponse|grpc:Error {
        map<string|string[]> headers = {};
        ListAllCarsRequest message;
        if req is ContextListAllCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/listAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ListAllCarsResponse>result, headers: respHeaders};
    }

    isolated remote function searchCar(SearchForCarRequest|ContextSearchForCarRequest req) returns SearchForCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchForCarRequest message;
        if req is ContextSearchForCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/searchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchForCarResponse>result;
    }

    isolated remote function searchCarContext(SearchForCarRequest|ContextSearchForCarRequest req) returns ContextSearchForCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchForCarRequest message;
        if req is ContextSearchForCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/searchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchForCarResponse>result, headers: respHeaders};
    }

    isolated remote function addToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/addToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function addToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/addToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function placeReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/placeReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationResponse>result;
    }

    isolated remote function placeReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRental/placeReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationResponse>result, headers: respHeaders};
    }

    isolated remote function createUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("carrental.CarRental/createUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class CarRentalUpdateCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUpdateCarResponse(UpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUpdateCarResponse(ContextUpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalRemoveCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveCarResponse(RemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveCarResponse(ContextRemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalSearchForCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchForCarResponse(SearchForCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchForCarResponse(ContextSearchForCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalPlaceReservationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPlaceReservationResponse(PlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPlaceReservationResponse(ContextPlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalAddToCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddToCartResponse(AddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddToCartResponse(ContextAddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalAddCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddCarResponse(AddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddCarResponse(ContextAddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalListAllCarsResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendListAllCarsResponse(ListAllCarsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextListAllCarsResponse(ContextListAllCarsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextListAllCarsRequest record {|
    ListAllCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationResponse record {|
    PlaceReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextSearchForCarRequest record {|
    SearchForCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchForCarResponse record {|
    SearchForCarResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarResponse record {|
    AddCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarResponse record {|
    UpdateCarResponse content;
    map<string|string[]> headers;
|};

public type ContextListAllCarsResponse record {|
    ListAllCarsResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarResponse record {|
    RemoveCarResponse content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ListAllCarsRequest record {|
    string filter = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type User record {|
    string userName = "";
    string role = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type PlaceReservationResponse record {|
    string confirmation = "";
    float totalPrice = 0.0;
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type SearchForCarRequest record {|
    string plateNumber = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type SearchForCarResponse record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type UpdateCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddCarResponse record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddToCartResponse record {|
    string message = "";
    ItemInCart item = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ItemInCart record {|
    string plateNumber = "";
    string startingDate = "";
    string endingDate = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type UpdateCarResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ListAllCarsResponse record {|
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddToCartRequest record {|
    ItemInCart item = {};
    string user = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type RemoveCarResponse record {|
    string message = "";
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type Reservation record {|
    string userName = "";
    ItemInCart[] items = [];
    float totalPrice = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type Car record {|
    string make = "";
    string model = "";
    int year = 0;
    string plateNumber = "";
    float price = 0.0;
    int kilos = 0;
    string status = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type PlaceReservationRequest record {|
    string userName = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type CreateUsersResponse record {|
    string message = "";
|};
