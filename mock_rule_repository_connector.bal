import ballerinax/health.fhir.r4;

# Implement this class to connect to the rule repository
# This class should be able to fetch the rules from the repository
# and make the decisions based on the rules
isolated class MockRuleRepositoryConnector {
    *RuleRepositoryConnector;

    private Prefetch prefetch;

    function init() {
        //initialize the connection to the rule repository
        self.prefetch = new Prefetch();
    }

    isolated function appointment_book(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error appointment_book_resources = self.prefetch.prefetch_from_EHR_server("appointment-book", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (appointment_book_resources is error) {
                    return appointment_book_resources;
                }
                prefetch_resources = appointment_book_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            CdsResponse cdsResponse = {
                    "cards": [
                        {
                            "uuid": "4e0a3a1e-3283-4575-ab82-028d55fe2719",
                            "summary": "Example Card",
                            "indicator": "info",
                            "detail": "This is an example card.",
                            "source": {
                                "label": "Static CDS Service Example",
                                "url": "https://example.com",
                                "icon": "https://example.com/img/icon-100px.png"
                            },
                            "links": [
                                {
                                    "label": "Google",
                                    "url": "https://google.com",
                                    "type": "absolute"
                                },
                                {
                                    "label": "Github",
                                    "url": "https://github.com",
                                    "type": "absolute"
                                },
                                {
                                    "label": "SMART Example App",
                                    "url": "https://smart.example.com/launch",
                                    "type": "smart",
                                    "appContext": "{\"session\":3456356,\"settings\":{\"module\":4235}}"
                                }
                            ]
                        },
                        {
                            "summary": "Another card",
                            "indicator": "warning",
                            "source": {
                                "label": "Static CDS Service Example"
                            },
                            "overrideReason": [
                                {
                                "code": "reason-code-provided-by-service",
                                "system": "http://example.org/cds-services/fhir/CodeSystem/override-reasons",
                                "display": "Patient refused"
                                },
                                {
                                "code": "12354",
                                "system": "http://example.org/cds-services/fhir/CodeSystem/override-reasons",
                                "display": "Contraindicated"
                                }
                            ]
                        }
                    ]
            };
            return cdsResponse.clone();
        }
    }

    isolated function patient_view(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error patient_view_resources = self.prefetch.prefetch_from_EHR_server("patient-view", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (patient_view_resources is error) {
                    return patient_view_resources;
                }
                prefetch_resources = patient_view_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function order_sign(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error order_sign_resources = self.prefetch.prefetch_from_EHR_server("order-sign", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (order_sign_resources is error) {
                    return order_sign_resources;
                }
                prefetch_resources = order_sign_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card sample_card = {
                "summary": "High risk for opioid overdose - taper now",
                "indicator": "warning",
                "links": [ 
                    {
                    "label": "CDC guideline for prescribing opioids for chronic pain",
                    "type": "absolute",
                    "url": "https://guidelines.gov/summaries/summary/50153/cdc-guideline-for-prescribing-opioids-for-chronic-pain---united-states-2016#420"
                    },
                    {
                    "label": "MME Conversion Tables",
                    "type": "absolute",
                    "url": "https://www.cdc.gov/drugoverdose/pdf/calculating_total_daily_dose-a.pdf"
                    }
                ],
                "detail": "Total morphine milligram equivalent (MME) is 125mg. Taper to less than 50.",
                "source":{
                    "label": "Sample Label"
                }
            };
            Card[] cards = [sample_card];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function order_select(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error order_select_resources = self.prefetch.prefetch_from_EHR_server("order-select", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (order_select_resources is error) {
                    return order_select_resources;
                }
                prefetch_resources = order_select_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            CdsResponse cdsResponse = {
                    "cards":[

                    ],
                    "systemActions":[
                        {
                            "description" : "This is a sample Request",
                            "type":"update",
                            "resource":{
                                "resourceType":"ServiceRequest",
                                "id":"example-MRI-59879846",
                                "extension":[
                                {
                                    "url":"http://fhir.org/argonaut/Extension/pama-rating",
                                    "valueCodeableConcept":{
                                        "coding":[
                                            {
                                            "system":"http://fhir.org/argonaut/CodeSystem/pama-rating",
                                            "code":"appropriate"
                                            }
                                        ]
                                    }
                                },
                                {
                                    "url":"http://fhir.org/argonaut/Extension/pama-rating-consult-id",
                                    "valueUri":"urn:uuid:55f3b7fc-9955-420e-a460-ff284b2956e6"
                                }
                                ],
                                "status":"draft",
                                "intent":"plan",
                                "code":{
                                "coding":[
                                    {
                                        "system":"http://loinc.org",
                                        "code":"36801-9"
                                    }
                                ],
                                "text":"MRA Knee Vessels Right"
                                },
                                "subject":{
                                "reference":"Patient/MRI-59879846"
                                },
                                "reasonCode":[
                                {
                                    "coding":[
                                        {
                                            "system":"http://hl7.org/fhir/sid/icd-10",
                                            "code":"S83.511",
                                            "display":"Sprain of anterior cruciate ligament of right knee"
                                        }
                                    ]
                                }
                                ]
                            }
                        }
                    ]
            };
            return cdsResponse.clone();
        }
    }

    isolated function order_dispatch(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error order_dispatch_resources = self.prefetch.prefetch_from_EHR_server("order-dispatch", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (order_dispatch_resources is error) {
                    return order_dispatch_resources;
                }
                prefetch_resources = order_dispatch_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function encounter_start(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error encounter_start_resources = self.prefetch.prefetch_from_EHR_server("encounter-start", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (encounter_start_resources is error) {
                    return encounter_start_resources;
                }
                prefetch_resources = encounter_start_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function encounter_end(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            map<r4:DomainResource> prefetch_resources = {};

            // To avoid modifying the original request, clone the request
            CdsRequest req_clone = cdsRequest.clone();

            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error encounter_end_resources = self.prefetch.prefetch_from_EHR_server("encounter-discharge", req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (encounter_end_resources is error) {
                    return encounter_end_resources;
                }
                prefetch_resources = encounter_end_resources;
            } else {
                prefetch_resources = <map<r4:DomainResource>>req_clone.prefetch;
            }

            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function feedback(string hook, Feedback feedback) {
        // Implement the feedback logic
    }
}
