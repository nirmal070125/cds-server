import ballerina/http;
import ballerina/io;
import ballerina/test;

http:Client testClient = check new ("http://localhost:8080/");

//------------------------------------------------------------------------------------------------
// Test cases for discovery endpoint
//------------------------------------------------------------------------------------------------

@test:BeforeGroups {value: ["discovery_endpoint_tests"]}
function before_discovery_test() {
    io:println("Starting discovery endpoint tests");
}

// Disabled Authentication for testing purposes
@test:Config {groups: ["discovery_endpoint_tests"]}
function positive_test_discovery_endopoint() returns error? {
    http:Response res = check testClient->get("/cds-services");
    test:assertEquals(res.statusCode, 200, "Status code should be 200");
}

// Add negative testcases
// Add testcases with JWT token

@test:AfterGroups {value: ["discovery_endpoint_tests"]}
function after_discovery_test() {
    io:println("Finishing discovery endpoint tests");
}

//------------------------------------------------------------------------------------------------
// Test cases for appointment-book endpoint
//------------------------------------------------------------------------------------------------

@test:BeforeGroups {value: ["appointment_book_tests"]}
function before_appointment_book_test() {
    io:println("Starting discovery endpoint tests");
}

// Disabled Authentication for testing purposes
@test:Config {groups: ["appointment_book_tests"]}
function positive_test_appointment_book_1() returns error? {
    // Define the payload for patient #1
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hooks.smarthealthit.org:9080",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288992",
                "active": true
            }
        }
    };
    http:Response res = check testClient->post("/cds-services/appointment-book", payload);
    test:assertEquals(res.statusCode, 200, "Status code should be 200");
}

@test:Config {groups: ["appointment_book_tests"]}
function positive_test_appointment_book_2() returns error? {
    // Define the payload for patient #2
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hooks.smarthealthit.org:9080",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        },
        "prefetch": {
            "patientToGreet": {
                "resourceType": "Patient",
                "gender": "male",
                "birthDate": "1925-12-23",
                "id": "1288933",
                "active": true
            }
        }
    };
    http:Response res = check testClient->post("/cds-services/appointment-book", payload);
    test:assertEquals(res.statusCode, 200, "Status code should be 200");
}

@test:Config {groups: ["appointment_book_tests"]}
function negative_test_appointment_book() {
    // Define the payload to fail with satuscode 412
    json payload = {
        "hookInstance": "d1577c69-dfbe-44ad-ba6d-3e05e953b2ea",
        "fhirServer": "http://hooks.smarthealthit.org:9080",
        "hook": "patient-view",
        "fhirAuthorization": {
            "access_token": "some-opaque-fhir-access-token",
            "token_type": "Bearer",
            "expires_in": 300,
            "scope": "user/Patient.read user/Observation.read",
            "subject": "cds-service4"
        },
        "context": {
            "userId": "Practitioner/example",
            "patientId": "1288992",
            "encounterId": "89284"
        }
    };
    http:Response|http:ClientError res = testClient->post("/cds-services/appointment-book", payload);
    if (res is http:ClientError) {
        io:println(res);
        test:assertFail("Failed with unknown error");
    }
    test:assertEquals(res.statusCode, 412, "Status code should be 412");
}

@test:AfterGroups {value: ["appointment_book_tests"]}
function after_appointment_book_test() {
    io:println("Finishing discovery endpoint tests");
}
