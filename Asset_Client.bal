The client:
import ballerina/io;
import ballerina/http;

http:Client assetClient = check new ("http://localhost:8080/NUST");

public function main() returns error?{

    json asset = {
        "assetTag":1,
        "name":"Vehicle",
        "faculty":"department",
        "department":"Informatics",
        "current_status":"INACTIVE",
        "dateAcquired":"2025-09-09",
        "schedules":[],
        "components":["Dashboard"],
        "workOrders":[]
        
    };

    json asset1 = {
        "assetTag":2,
        "name":"Vehicle",
        "faculty":"Computing&Informatics",
        "department":"Informatics",
        "current_status":"ACTIVE",
        "dateAcquired":"2025-01-01",
        "schedules":[],
        "components":["Tire","Dashboard"],
        "workOrders":[]
        
    };
    json schedule = {
        "scheduleID":1,
        "dueBy":"2025-09-10"

    };

    //json workOrder = {};

    string serverResponse;

    serverResponse = check assetClient->post("/addAsset", asset);
    io:println("response to addAsset function: ", serverResponse);

    serverResponse = check assetClient->post("/addAsset", asset1);
    io:println("response to addAsset function: ", serverResponse);

    serverResponse = check assetClient->put("/updateAssetName/1/MotorVehicle", ());
    io:println("response to updateAssetName function: ",serverResponse);

    serverResponse = check assetClient->put("/updateAssetStatus/1/ACTIVE",());
    io:println("response to updateAssetStatus function: ",serverResponse);

    serverResponse = check assetClient->get("/viewAssets");
    io:println("response toviewAssets function", serverResponse);

    serverResponse = check assetClient->get("/viewAssetsByFaculty/Computing&Informatics");
    io:println("response to viewAssetsByFaculty function", serverResponse);

    serverResponse = check assetClient->post("/addComponentByAsset/1/Gearbox", ());
    io:println("response to addComponentByAsset function: ", serverResponse);

    serverResponse = check assetClient->post("/addComponentByAsset/1/HandBrake", ());
    io:println("response to addComponentByAsset function: ", serverResponse);

    serverResponse = check assetClient->post("/addComponentByAsset/1/Transmission", ());
    io:println("response to addComponentByAsset function: ", serverResponse);

    serverResponse = check assetClient->post("/addSchedule?id=1", schedule);
    io:println("responese to addSchedule fnuction: ", serverResponse);

    serverResponse = check assetClient->delete("/deleteComponent/1/HandBrake", ());
    io:println("response to deleteComponent function: ", serverResponse);

    serverResponse = check assetClient->get("/returnOverdueAssets");
    io:println("repsonse to returnOverdueAssets function: ", serverResponse);
}