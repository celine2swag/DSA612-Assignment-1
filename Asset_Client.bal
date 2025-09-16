import ballerina/http;
import ballerina/io;

http:Client assetClient = check new("http://localhost:10000/assets");

public function main() returns error? {

   
    json newAsset = {
        "assetTag": "EQ-001",
        "name": "3D Printer",
        "faculty": "Computing & Informatics",
        "department": "Software Engineering",
        "status": "ACTIVE",
        "acquiredDate": "2024-03-10"
    };

    http:Response createRes = check assetClient->post("/", newAsset);
    io:println("Create Response: ", check createRes.getJsonPayload());

    // View all assets
    http:Response allRes = check assetClient->get("/");
    io:println("All Assets: ", check allRes.getJsonPayload());

    // View single asset
    http:Response singleRes = check assetClient->get("/EQ-001");
    io:println("Single Asset: ", check singleRes.getJsonPayload());

    // Update asset
    json updatedAsset = {
        "assetTag": "EQ-001",
        "name": "3D Printer - Updated",
        "faculty": "Computing & Informatics",
        "department": "Software Engineering",
        "status": "UNDER_REPAIR",
        "acquiredDate": "2024-03-10"
    };

    http:Response updateRes = check assetClient->put("/EQ-001", updatedAsset);
    io:println("Update Response: ", check updateRes.getJsonPayload());

    // Filter by faculty
    http:Response facultyRes = check assetClient->get("/faculty/Computing & Informatics");
    io:println("Assets by Faculty: ", check facultyRes.getJsonPayload());

    // Add a component
    json newComp = { "id": "C001", "name": "Extruder Motor" };
    http:Response addCompRes = check assetClient->post("/EQ-001/components", newComp);
    io:println("Add Component Response: ", check addCompRes.getJsonPayload());

    // Add a schedule
    json newSchedule = { "id": "S001", "nextDueDate": "2024-04-01" };
    http:Response addSchRes = check assetClient->post("/EQ-001/schedules", newSchedule);
    io:println("Add Schedule Response: ", check addSchRes.getJsonPayload());

    // Check overdue items
    http:Response overdueRes = check assetClient->get("/overdue");
    io:println("Overdue Assets: ", check overdueRes.getJsonPayload());

    // Delete a component
    http:Response delCompRes = check assetClient->delete("/EQ-001/components/C001");
    io:println("Delete Component Response: ", check delCompRes.getJsonPayload());

    // Delete a schedule
    http:Response delSchRes = check assetClient->delete("/EQ-001/schedules/S001");
    io:println("Delete Schedule Response: ", check delSchRes.getJsonPayload());

    // Delete asset
    http:Response delAssetRes = check assetClient->delete("/EQ-001");
    io:println("Delete Asset Status: ", delAssetRes.statusCode.toString());
}
