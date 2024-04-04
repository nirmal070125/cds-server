import ballerina/http;

isolated function getReponse(CdsResponse|error res) returns http:Response{
    http:Response response = new;
    if (res is error){
        // 412 Precondition Failed
        response.statusCode = 412;
        response.setTextPayload(res.message());
        return response;
    }
    response.statusCode = 200;
    response.setPayload(res.toJson());
    return response;
}