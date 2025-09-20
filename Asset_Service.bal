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
}