import ballerina/http;
import ballerina/io;

listener http:Listener httpListener = new (8080);

service / on httpListener {
    resource function get cds\-services() returns Services {
        CdsService cdsService = {
            "hook": "patient-view",
            "title": "Static CDS Service Example",
            "description": "An example of a CDS Service that returns a static set of cards",
            "id": "static-patient-greeter",
            "prefetch": {
                "patientToGreet": "Patient/{{context.patientId}}"
            }
        };
        Services services = {services: [cdsService]};
        return services;
    }

    resource function post cds\-services/appointment\-book(@http:Payload CdsRequest payload) {
        io:println("Received request to book an appointment for patient: ", payload);
    }
}
