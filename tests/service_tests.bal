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
            "userId": "PractitionerRole/A2340113",
            "patientId": "1288992",
            "encounterId": "456",
            "appointments": [
                {
                    "resourceType": "Appointment",
                    "id": "example",
                    "text": {
                        "status": "generated",
                        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\">Brian MRI results discussion</div>"
                    },
                    "status": "proposed",
                    "serviceCategory": {
                        "coding": [
                            {
                                "system": "http://example.org/service-category",
                                "code": "gp",
                                "display": "General Practice"
                            }
                        ]
                    },
                    "serviceType": [
                        {
                            "coding": [
                                {
                                    "code": "52",
                                    "display": "General Discussion"
                                }
                            ]
                        }
                    ],
                    "specialty": [
                        {
                            "coding": [
                                {
                                    "system": "http://example.org/specialty",
                                    "code": "gp",
                                    "display": "General Practice"
                                }
                            ]
                        }
                    ],
                    "appointmentType": {
                        "coding": [
                            {
                                "system": "http://example.org/appointment-type",
                                "code": "follow",
                                "display": "Followup"
                            }
                        ]
                    },
                    "indication": [
                        {
                            "reference": "Condition/example",
                            "display": "Severe burn of left ear"
                        }
                    ],
                    "priority": 5,
                    "description": "Discussion on the results of your recent MRI",
                    "start": "2013-12-10T09:00:00Z",
                    "end": "2013-12-10T11:00:00Z",
                    "created": "2013-10-10",
                    "comment": "Further expand on the results of the MRI and determine the next actions that may be appropriate.",
                    "incomingReferral": [
                        {
                            "reference": "ReferralRequest/example"
                        }
                    ],
                    "participant": [
                        {
                            "actor": {
                                "reference": "Patient/example",
                                "display": "Peter James Chalmers"
                            },
                            "required": "required",
                            "status": "tentative"
                        },
                        {
                            "type": [
                                {
                                    "coding": [
                                        {
                                            "system": "http://hl7.org/fhir/v3/ParticipationType",
                                            "code": "ATND"
                                        }
                                    ]
                                }
                            ],
                            "actor": {
                                "reference": "Practitioner/example",
                                "display": "Dr Adam Careful"
                            },
                            "required": "required",
                            "status": "accepted"
                        },
                        {
                            "actor": {
                                "reference": "Location/1",
                                "display": "South Wing, second floor"
                            },
                            "required": "required",
                            "status": "action-needed"
                        }
                    ]
                }
            ]
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
