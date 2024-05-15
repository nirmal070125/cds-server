import ballerina/http;
import ballerinax/health.fhir.r4;

# Implement this class to connect to the rule repository
# This class should be able to fetch the rules from the repository
# and make the decisions based on the rules
isolated class MockRuleRepositoryConnector {
    *RuleRepositoryConnector;

    private http:Client ruleRepositoryClient;
    private Prefetch prefetch;

    function init() {
        self.prefetch = new Prefetch();
        self.ruleRepositoryClient = checkpanic new http:Client(MOCK_RULE_REPOSITORY_URL);
    }

    isolated function execute(CdsRequest cdsRequest) returns CdsResponse|error {
        // If the prefetch is not available, fetch the prefetch from the EHR server and update the request body
        lock {
            CdsRequest req_clone = cdsRequest.clone();
            if (cdsRequest.prefetch == ()) {
                map<r4:DomainResource>|error res = self.prefetch.prefetch_from_EHR_server(req_clone.hook, req_clone.context, <string>req_clone.fhirServer, <FhirAuthorization>req_clone.fhirAuthorization);
                if (res is error) {
                    return res;
                }
                req_clone.prefetch = res;
            }
        }

        match cdsRequest.hook {
            "appointment-book" => {
                return self.appointment_book(cdsRequest);
            }
            "order-sign" => {
                return self.order_sign(cdsRequest);
            }
            "order-dispatch" => {
                return self.order_dispatch(cdsRequest);
            }
            "encounter-start" => {
                return self.encounter_start(cdsRequest);
            }
            "encounter-discharge" => {
                return self.encounter_end(cdsRequest);
            }
            "order-select" => {
                return self.order_select(cdsRequest);
            }
        }

        // connect with the CRD server and do the relevant operation
        // Get the response from the rule server
        // put Coverage info in the extension : https://hl7.org/fhir/us/davinci-crd/StructureDefinition-ext-coverage-information.html
        // Even if there are no cards to be returned, for the primary hooks return the coverage info in system action
        return error("Invalid hook provided. Please provide a valid hook.");
    }

    isolated function appointment_book(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            // Develop the logic for the appointment book
            // Use the rule server
            CdsResponse cdsResponse = {
                "cards": [],
                "systemActions": [
                    {
                        "type": "create",
                        "description": "Annotated appointment request with Coverage information",
                        "resource": {
                            "resourceType": "Appointment",
                            "id": "example-appointment-123",
                            "status": "proposed",
                            "description": "Sample appointment",
                            "start": "2021-01-01T10:00:00Z",
                            "end": "2021-01-01T11:00:00Z",
                            "participant": [
                                {
                                    "actor": {
                                        "reference": "Patient/example-patient-123"
                                    }
                                }
                            ],
                            "extension": [
                                {
                                    "url": "coverage",
                                    "valueReference": {
                                        "reference": "Coverage/example"
                                    }
                                },
                                {
                                    "url": "covered",
                                    "valueCode": "conditional"
                                },
                                {
                                    "url": "pa-needed",
                                    "valueCode": "satisfied"
                                },
                                {
                                    "url": "doc-needed",
                                    "valueCode": "admin"
                                },
                                {
                                    "url": "doc-purpose",
                                    "valueCode": "withclaim"
                                },
                                {
                                    "url": "info-needed",
                                    "valueCode": "performer"
                                },
                                {
                                    "url": "billingCode",
                                    "valueCoding": {
                                        "system": "http://www.ama-assn.org/go/cpt",
                                        "code": "77067"
                                    }
                                },
                                {
                                    "url": "reason",
                                    "valueCodeableConcept": {
                                        "coding": [
                                            {
                                                "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
                                                "code": "gold-card"
                                            }
                                        ],
                                        "text": "In-network required unless exigent circumstances"
                                    }
                                }
                            ]
                        }
                    }
                ]
            };
            return cdsResponse.clone();
        }
    }

    isolated function order_sign(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
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
                "source": {
                    "label": "Sample Label"
                }
            };
            Card sample_card_2 = {

                summary: "Caution: Potential Drug-Kidney Interaction",
                indicator: "warning",
                detail: "Patient has a history of renal impairment. Consider dosage adjustment for the ordered medication.",
                "source": {
                    label: "ACME Drug Safety CDS",
                    url: "http://acme.org/drug-safety-cds"
                },
                suggestions: [
                    {
                        "label": "Reduce dosage by 50%",
                        "uuid": "suggestion-1",
                        "actions": [
                            {
                                "type": "update",
                                "description": "Adjust dosage in order form"
                            }
                        ]
                    },
                    {
                        "label": "Reduce dosage by 70%",
                        "uuid": "suggestion-2",
                        "actions": [
                            {
                                "type": "update",
                                "description": "Adjust dosage in order form"
                            }
                        ]
                    },
                    {
                        "label": "Reduce dosage by 5%",
                        "uuid": "suggestion-3",
                        "actions": [
                            {
                                "type": "update",
                                "description": "Adjust dosage in order form"
                            }
                        ]
                    }
                ],
                "selectionBehavior": "at-most-one",
                "links": [
                    {
                        "label": "Renal Dosing Guidelines",
                        "url": "https://www.guidelines.gov/renal-dosing",
                        "type": "absolute"
                    }
                ]
            };

            Action sysAction = {
                "type": "create",
                "description": "Annotated order with Coverage information",
                "resource": {
                    "resourceType": "ServiceRequest",
                    "id": "example-MRI-59879846",
                    "status": "draft",
                    "intent": "order",
                    "extension": [
                        {
                            "url": "coverage",
                            "valueReference": {
                                "reference": "Coverage/example"
                            }
                        },
                        {
                            "url": "covered",
                            "valueCode": "conditional"
                        },
                        {
                            "url": "pa-needed",
                            "valueCode": "satisfied"
                        },
                        {
                            "url": "doc-needed",
                            "valueCode": "admin"
                        },
                        {
                            "url": "doc-purpose",
                            "valueCode": "withclaim"
                        },
                        {
                            "url": "info-needed",
                            "valueCode": "performer"
                        },
                        {
                            "url": "billingCode",
                            "valueCoding": {
                                "system": "http://www.ama-assn.org/go/cpt",
                                "code": "77067"
                            }
                        },
                        {
                            "url": "reason",
                            "valueCodeableConcept": {
                                "coding": [
                                    {
                                        "system": "http://hl7.org/fhir/us/davinci-crd/CodeSystem/temp",
                                        "code": "gold-card"
                                    }
                                ],
                                "text": "In-network required unless exigent circumstances"
                            }
                        }
                    ]

                }
            };
            Action[] sysActions = [sysAction];
            Card[] cards = [sample_card, sample_card_2];
            CdsResponse cdsResponse = {cards: cards, systemActions: sysActions};
            return cdsResponse.clone();

        }
    }

    isolated function order_dispatch(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

    isolated function order_select(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
            // Develop the logic for the appointment book
            // Use the rule server
            CdsResponse cdsResponse = {
                "cards": []
            };
            return cdsResponse.clone();
        }
    }

    isolated function encounter_start(CdsRequest cdsRequest) returns CdsResponse|error {
        lock {
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
            // Develop the logic for the appointment book
            // Use the rule server
            // Return the cards
            Card[] cards = [];
            CdsResponse cdsResponse = {cards: cards};
            return cdsResponse.clone();
        }
    }

}
