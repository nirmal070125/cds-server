import ballerina/http;

listener http:Listener httpListener = new (8080);

final MockRuleRepositoryConnector mockRuleRepositoryConnector = new();

configurable string MOCK_RULE_REPOSITORY_URL = ?;

service / on httpListener {
    isolated resource function get cds\-services(http:Headers headers) returns Services|http:Response {
        // string|error jwt_token = headers.getHeader("Authorization");
        // if (jwt_token is error) {
        //     http:Response res = new;
        //     res.statusCode = 401;
        //     res.setTextPayload(jwt_token.message());
        //     return res;
        // }
        // error? authError = jwtAuth(jwt_token);
        // if (authError is error) {
        //     http:Response res = new;
        //     res.statusCode = 401;
        //     res.setTextPayload(authError.message());
        //     return res;
        // }
    
        CdsService patientCdsService = {
            "hook": "patient-view",
            "title": "Static CDS Service Example",
            "description": "An example of a CDS Service that returns a static set of cards",
            "id": "static-patient-greeter",
            "prefetch": {
                "patientToGreet": "Patient/{{context.patientId}}"
            }
        };
        CdsService appointmentCdsService = {
            "hook": "appointment-book",
            "title": "Static CDS Service Example",
            "description": "An example of a CDS Service that returns a static set of cards",
            "id": "static-appointment-book",
            "prefetch": {
                "patientToGreet": "Patient/{{context.patientId}}"
            }
        };
        CdsService[] supported_services = [patientCdsService, appointmentCdsService];
        Services services = {services: supported_services};

        return services;
    }

    isolated resource function post cds\-services/appointment\-book(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-sign(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-select(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/order\-dispatch(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/encounter\-start(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

    isolated resource function post cds\-services/encounter\-discharge(@http:Payload CdsRequest payload) returns http:Response{
        CdsResponse|error res = mockRuleRepositoryConnector.execute(payload);
        http:Response response = getReponse(res);
        return response;
    }

}
