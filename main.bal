import ballerina/http;
import ballerina/io;

listener http:Listener httpListener = new (8080);

final RuleRepositoryConnector ruleRepositoryConnector = new();

service / on httpListener {
    isolated resource function get cds\-services(http:Headers headers) returns Services|http:Response {
        string|error jwt_token = headers.getHeader("Authorization");
        if (jwt_token is error) {
            http:Response res = new;
            res.statusCode = 401;
            res.setTextPayload(jwt_token.message());
            return res;
        }
        error? authError = jwtAuth(jwt_token);
        if (authError is error) {
            http:Response res = new;
            res.statusCode = 401;
            res.setTextPayload(authError.message());
            return res;
        }
        Services services = ruleRepositoryConnector.discovery_endpoint();
        return services;
    }

    isolated resource function post cds\-services/appointment\-book(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.appointment_book(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/patient\-view(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.patient_view(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/order\-sign(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.order_sign(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/order\-select(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.order_select(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/order\-dispatch(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.order_dispatch(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/encounter\-start(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.encounter_start(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/encounter\-discharge(@http:Payload CdsRequest payload) returns http:Response{
        Card[]|error cards = ruleRepositoryConnector.encounter_end(payload);
        http:Response response = getReponse(cards);
        return response;
    }

    isolated resource function post cds\-services/appointment\-book/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for appointment-book: ", payload);
        ruleRepositoryConnector.feedback("appointment-book", payload);
    }

    isolated resource function post cds\-services/patient\-view/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for patient-view: ", payload);
        ruleRepositoryConnector.feedback("patient-view", payload);
    }

    isolated resource function post cds\-services/order\-sign/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-sign: ", payload);
        ruleRepositoryConnector.feedback("order-sign", payload);
    }

    isolated resource function post cds\-services/order\-select/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-select: ", payload);
        ruleRepositoryConnector.feedback("order-select", payload);
    }

    isolated resource function post cds\-services/order\-dispatch/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-dispatch: ", payload);
        ruleRepositoryConnector.feedback("order-dispatch", payload);
    }

    isolated resource function post cds\-services/encounter\-start/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for encounter-start: ", payload);
        ruleRepositoryConnector.feedback("encounter-start", payload);
    }

    isolated resource function post cds\-services/encounter\-discharge/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for encouter-discharge: ", payload);
        ruleRepositoryConnector.feedback("encounter-discharge", payload);
    }
}
