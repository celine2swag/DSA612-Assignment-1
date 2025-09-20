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


}