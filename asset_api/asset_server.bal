import ballerina/http;
listener http:Listener assetListener = new(9090);
service /assets on assetListener{
    
    resource function post .(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        Asset newAsset = check payload.cloneWithType(Asset);

        if assetDB.hasKey(newAsset.assetTag) {
            check caller->respond({message: "Asset already exists"});
            return;
        }

        assetDB[newAsset.assetTag] = newAsset;
        check caller-> respond({message: "Asset created", assetTag: newAsset.assetTag});
    }
    //when called, releases full list of assets
    resource function get .(http:Caller caller) returns error? {
    check caller->respond(assetDB);
}
};

//record definition
type Component record{|
    string id;
    string name;
|};

type Schedule record {|
    string id;
    string description;
    string dueDate;
|};

type Task record {|
    string id;
    string description;
    string status;
|};

type Work_Order record {|
    string id;
    string description;
    string status ;
    Task[] tasks;
|};

type Asset record {|
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    Component[] components;
    Schedule[] schedules;
    Work_Order[] workOrders;
|};

map<Asset> assetDB = {};


