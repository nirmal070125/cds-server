import ballerina/http;
import ballerina/io;

listener http:Listener httpListener = new (8080);

final MockRuleRepositoryConnector mockRuleRepositoryConnector = new();

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
    
        CdsService cdsService = {
            "hook": "patient-view",
            "title": "Static CDS Service Example",
            "description": "An example of a CDS Service that returns a static set of cards",
            "id": "static-patient-greeter",
            "prefetch": {
                "patientToGreet": "Patient/{{context.patientId}}"
            }
        };
        CdsService[] supported_services = [cdsService];
        Services services = {services: supported_services};

        return services;
    }

    isolated resource function post cds\-services/appointment\-book(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.appointment_book(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/patient\-view(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.patient_view(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-sign(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.order_sign(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-select(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.order_select(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-dispatch(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.order_dispatch(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/encounter\-start(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.encounter_start(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/encounter\-discharge(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.encounter_end(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/appointment\-book/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for appointment-book: ", payload);
        mockRuleRepositoryConnector.feedback("appointment-book", payload);
    }

    isolated resource function post cds\-services/patient\-view/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for patient-view: ", payload);
        mockRuleRepositoryConnector.feedback("patient-view", payload);
    }

    isolated resource function post cds\-services/order\-sign/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-sign: ", payload);
        mockRuleRepositoryConnector.feedback("order-sign", payload);
    }

    isolated resource function post cds\-services/order\-select/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-select: ", payload);
        mockRuleRepositoryConnector.feedback("order-select", payload);
    }

    isolated resource function post cds\-services/order\-dispatch/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for order-dispatch: ", payload);
        mockRuleRepositoryConnector.feedback("order-dispatch", payload);
    }

    isolated resource function post cds\-services/encounter\-start/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for encounter-start: ", payload);
        mockRuleRepositoryConnector.feedback("encounter-start", payload);
    }

    isolated resource function post cds\-services/encounter\-discharge/feedback(@http:Payload Feedback payload) {
        io:println("Received feedback for encouter-discharge: ", payload);
        mockRuleRepositoryConnector.feedback("encounter-discharge", payload);
    }
}
