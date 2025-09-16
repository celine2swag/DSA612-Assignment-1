import ballerina/http;
import ballerina/lang.value;

type Component record {|
    string id;
    string name;
|};

type Schedule record {|
    string id;
    string nextDueDate; 
|};

type Asset record {|
    string assetTag;
    string name;
    string faculty;
    string department;
    string status; 
    string acquiredDate;
    Component[] components = [];
    Schedule[] schedules = [];
|};

map<Asset> assets = {};

service /assets on new http:Listener(10000) {

    // Create asset
    resource function post .(http:Request req) returns http:Response|error {
        json payload = check req.getJsonPayload();
        if payload is map<json> {
            Asset asset = {
                assetTag: <string>payload["assetTag"],
                name: <string>payload["name"],
                faculty: <string>payload["faculty"],
                department: <string>payload["department"],
                status: <string>payload["status"],
                acquiredDate: <string>payload["acquiredDate"],
                components: [],
                schedules: []
            };
            lock {
                assets[asset.assetTag] = asset;
            }

            http:Response res = new;
            res.statusCode = 201;
            json|error jsonPayload = value:toJson(asset);
            if jsonPayload is error {
                res.statusCode = 500;
                res.setJsonPayload({"error":"Failed to convert asset to JSON"});
                return res;
            }
            res.setJsonPayload(jsonPayload);
            return res;
        }

        http:Response res = new;
        res.statusCode = 400;
        res.setJsonPayload({"error":"Invalid payload"});
        return res;
    }

    // Get all assets
    resource function get .() returns http:Response {
        Asset[] list = [];
        lock {
            foreach var [_, a] in assets.entries() {
                list.push(a);
            }
        }
        http:Response res = new;
        res.statusCode = 200;
        json|error jsonPayload = value:toJson(list);
        if jsonPayload is error {
            res.statusCode = 500;
            res.setJsonPayload({"error":"Failed to convert assets to JSON"});
            return res;
        }
        res.setJsonPayload(jsonPayload);
        return res;
    }

    // Get single asset by assetTag
    resource function get [string assetTag]() returns http:Response {
        lock {
            Asset? a = assets[assetTag];
            if a is Asset {
                http:Response res = new;
                res.statusCode = 200;
                json|error jsonPayload = value:toJson(a);
                if jsonPayload is error {
                    res.statusCode = 500;
                    res.setJsonPayload({"error": "Failed to convert asset to JSON"});
                    return res;
                }
                res.setJsonPayload(jsonPayload);
                return res;
            }
        }
        http:Response res = new;
        res.statusCode = 404;
        res.setJsonPayload({"error": "Asset not found"});
        return res;
    }

   

}