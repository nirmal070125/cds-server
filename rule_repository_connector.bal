import ballerinax/health.fhir.r4;

# Implement this class to connect to the rule repository
# This class should be able to fetch the rules from the repository
# and make the decisions based on the rules
isolated class RuleRepositoryConnector {

    private Prefetch prefetch;

    function init() {
        //initialize the connection to the rule repository
        self.prefetch = new Prefetch();
    }

    isolated function discovery_endpoint() returns Services {
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

    isolated function appointment_book(CdsRequest cdsRequest) returns Card[]|error {
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
            // Return the cards
            Card[] cards = [];
            return cards.clone();
        }
    }

    isolated function patient_view(CdsRequest cdsRequest) returns Card[]|error {
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
            return cards.clone();
        }
    }

    isolated function order_sign(CdsRequest cdsRequest) returns Card[]|error {
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
            Card[] cards = [];
            return cards.clone();
        }
    }

    isolated function order_select(CdsRequest cdsRequest) returns Card[]|error {
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
            // Return the cards
            Card[] cards = [];
            return cards.clone();
        }
    }

    isolated function order_dispatch(CdsRequest cdsRequest) returns Card[]|error {
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
            return cards.clone();
        }
    }

    isolated function encounter_start(CdsRequest cdsRequest) returns Card[]|error {
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
            return cards.clone();
        }
    }

    isolated function encounter_end(CdsRequest cdsRequest) returns Card[]|error {
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
            return cards.clone();
        }
    }

    isolated function feedback(string hook, Feedback feedback) {
        // Implement the feedback logic
    }
}
