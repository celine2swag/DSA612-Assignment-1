//import ballerina/io;
import ballerina/time;
import ballerina/http;

int port = 8080;

//time:Date myDate = check time:createDate(2025, 9, 12);

public type Asset record{

    readonly int assetTag;
    string name;
    string faculty;
    string department;
    string current_status;
    string dateAcquired;
    Schedule[] schedules;
    string[] components;
    WorkOrder[] workOrders;

};

public type Schedule record{

    readonly int scheduleID;
    string dueBy;

};
public type WorkOrder record{

    readonly int workOrderID;
    string description;
    string status;
    string taskID;
    Task[] tasks;
};

public type Task record{

    readonly int taskID;
    string description;
};

table<Asset> key(assetTag) assetTable = table [
    
];

function parseStringDate(string date) returns time:Utc|error{
    
    string correctDateFormat = date + "T00:00:00Z";
    //2025-09-10T00:00:00Z
    // return time:utcFromString(correctDateFormat);
    time:Utc utcDateFormat; 
    return time:utcFromString(correctDateFormat); 
}
service /NUST on new http:Listener(port){

    resource function POST addAsset(@http:Payload Asset asset) returns string|error{

        if(assetTable.hasKey(asset.assetTag)){
            return "This key already exists";
        }else{
        assetTable.add(asset);
        }
        return "Asset has been added successfully!!!";
    } 

    resource function GET viewAssets() returns Asset[]{
            return assetTable.toArray();
    }

    resource function GET viewAssetsByFaculty/[string faculty]() returns Asset[]|http:NotFound{
        Asset[] assetList = [];
        foreach Asset asset in assetTable{
            if(asset.faculty == faculty){
                assetList.push(asset);
            }
        }
        if(assetList.length()<1){
            return http:NOT_FOUND;
        }
        return assetList;
    }


    resource function PUT updateAssetName/[int assetTag]/[string newName]() returns string|http:NotFound {
        //Asset asset;
        boolean found = false;
        foreach Asset asset in assetTable{
            if(asset.assetTag==assetTag){
                asset.name=newName;
                found=true;
                break;
            }
        }
        if(found!=true){
            return "Does not exist!!!";
        }
        return "Asset updated successfully";
    } 
 resource function PUT updateAssetStatus/[int id]/[string status]() returns string|http:NotFound{
        if(!assetTable.hasKey(id)){
            return http:NOT_FOUND;
        }
        else{
            foreach Asset asset in assetTable{
                if(asset.assetTag==id){
                    asset.current_status=status;
                }
            }
        }
        return "Status has been updated successfully";
    }

    resource function GET returnOverdueAssets() returns Asset[]|string{
        Asset[] overdueItems = [];
        time:Utc currentTime = time:utcNow();
        foreach Asset asset in assetTable{
            foreach Schedule scheduleString in asset.schedules {

                time:Utc|error scheduleDate = parseStringDate(scheduleString.dueBy);
    
                if(scheduleDate is time:Utc){
                    // Compare ISO-8601 strings; utcToString produces "YYYY-MM-DDTHH:MM:SSZ" so lexicographic comparison works
                    string scheduleIso = time:utcToString(scheduleDate);
                    string currentIso = time:utcToString(currentTime);
                    if (scheduleIso < currentIso) {
                        overdueItems.push(asset);
                        break;
                    }
                }
            }
        }
        return overdueItems;
    }
    //delete asset by id
    resource function DELETE removeAssetByid/[int id]() returns string|http:NotFound{
        Asset? Removedasset = assetTable.remove(id);
        if(Removedasset is ()){
            return "No asset with that id was found!!";
        }else{
        return "The removed asset id is:"+Removedasset.assetTag.toString();
        
}
    }

    //add component to asset by id
       resource function POST addComponentByAsset/[int id]/[string newComponent]() returns string|http:NotFound{
        if(!assetTable.hasKey(id)){
            return "niggerr";
        }

        boolean duplicateExists = false;
        foreach Asset asset in assetTable{
            if(asset.assetTag==id){
            foreach string component in asset.components{
                if(component==newComponent){
                    duplicateExists=true;
                    return "Component already exists";
                }
            }
            if(!duplicateExists==true){
                asset.components.push(newComponent);
            }
            }
        }
        return "Component added successfully";
}
}
