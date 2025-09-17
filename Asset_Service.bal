import ballerina/http;
import ballerina/time;



type Asset record {
    readonly int assetTag;
    string name;
    string faculty;
    string department;
    string current_status; //INACTIVE, ACTIVE, DISPOSED
    string dateAcquired;
    Schedule[] schedules; //[{"scheduleID":1, "dueBy":"2025-09-10"}, {}, {}]
    string[] components;  //["hard drive","power supply", "cooling fan"]
    WorkOrder[] workOrders;
};
type Schedule record {
    int scheduleID;
    string dueBy; 
};

type Task record{
    int taksID;
    string description;
};
type WorkOrder record{
    int wordOrderID;
    string description;
    string status;
    string taskID;
    Task[] tasks;
};

table<Asset> key(assetTag) assetTable = table [

];

service /assets on new http:Listener(10000) {
   
}