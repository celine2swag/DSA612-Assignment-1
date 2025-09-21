import ballerina/http;

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

table<Asset> key(assetTag) assetTable = table [];

service /NUST on new http:Listener(8080){

    resource function DELETE deleteComponent(int id, string name) returns string|http:NotFound{
        if(!assetTable.hasKey(id)){
            return http:NOT_FOUND;
        }
        boolean removed = false;
        string removedItem;
        foreach Asset asset in assetTable{
            if(asset.assetTag==id){
                int i = 0;
                while (i < asset.components.length()) {
                    if (asset.components[i] == name) {
                        removedItem = asset.components.remove(i);
                        removed = true;
                        break;
                    }
                    i += 1;
                }
                break;
            }
        }
        if (!removed) {
            return http:NOT_FOUND;
        }
        return "Component removed successfully";
    }

    resource function POST addSchedule(int id, @http:Payload Schedule clientSchedule) returns string|http:NotFound{
        if(!assetTable.hasKey(id)){
            return http:NOT_FOUND;
        }

        foreach Asset asset in assetTable{
            if(asset.assetTag==id){
                asset.schedules.push(clientSchedule);
            }
        } 
        return "Schedule added successfully!";
    } 
    
    resource function DELETE deleteSchedule(int id, int schedulesID) returns string|http:NotFound{
        if(!assetTable.hasKey(id)){
            return http:NOT_FOUND;
        }
        Schedule removedSchedule;
        foreach Asset asset in assetTable{
            if(asset.assetTag==id){
               int i = 0;
               while(i<asset.schedules.length()){
                if(asset.schedules[i].scheduleID==schedulesID){
                    removedSchedule = asset.schedules.remove(i);
                }   
                i += 1;
               }
            }
        }
        return "Schedule deleted successfully!!!";
    }
}
