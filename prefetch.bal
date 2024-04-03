import ballerina/http;
import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.parser as fhirParser;

class Prefetch {
    // TODO: Implement this as a static class
    isolated function get_patient_view_prefetch(PatientViewContext? patientViewContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (patientViewContext != ()) {
            patientId = patientViewContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_order_sign_prefetch(OrderSignContext? orderSigncontext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (orderSigncontext != ()) {
            patientId = orderSigncontext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_order_select_prefetch(OrderSelectContext? orderSelectContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (orderSelectContext != ()) {
            patientId = orderSelectContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_order_dispatch_prefetch(OrderDispatchContext? orderDispatchContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (orderDispatchContext != ()) {
            patientId = orderDispatchContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_appointment_book_prefetch(AppointmentBookContext? appointmentBookContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (appointmentBookContext != ()) {
            patientId = appointmentBookContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_encounter_start_prefetch(EncounterStartContext? encounterStartContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (encounterStartContext != ()) {
            patientId = encounterStartContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function get_encounter_discharge_prefetch(EncounterDischargeContext? encounterDischargeContext = ()) returns map<string> {
        string patientId = "{{context.patientId}}";
        if (encounterDischargeContext != ()) {
            patientId = encounterDischargeContext.patientId;
        }

        map<string> prefetch_templates = {
            "patientToGreet": string `Patient/${patientId}`
        };

        return prefetch_templates;
    }

    isolated function prefetch_from_EHR_server(string hook, Context context, r4:uri fhir_server_url, FhirAuthorization fhirAuthorization) returns map<r4:DomainResource>|error {
        map<string> prefetch_templates = check self.get_templates(hook, context);
        
        map<r4:DomainResource> prefetch_data = {};
        foreach var key_ in prefetch_templates.keys() {
            http:Client prefetchClient = check new (fhir_server_url);
            string path = <string>prefetch_templates[key_];

            if (path.includes("{")) {
                // Check the error message
                return error("Invalid path: Template is not initialized");
            }
            http:Response prefetchResponse = check prefetchClient->get(path,
                headers = {
                "Authorization": fhirAuthorization.token_type + " " + fhirAuthorization.access_token
            });

            json responseBody = check prefetchResponse.getJsonPayload();
            r4:DomainResource prefetchData = check fhirParser:parse(responseBody).ensureType();
            prefetch_data[key_] = prefetchData;
        }

        return prefetch_data;
    }

    isolated function get_templates(string hook, Context context) returns map<string>|error{
        match hook {
            "appointment-book" => {
                return self.get_appointment_book_prefetch(<AppointmentBookContext>context);
            }
            "patient-view" => {
                return self.get_patient_view_prefetch(<PatientViewContext>context);
            }
            "order-select" => {
                return self.get_order_select_prefetch(<OrderSelectContext>context);
            }
            "order-sign" => {
                return self.get_order_sign_prefetch(<OrderSignContext>context);
            }
            "order-dispatch" => {
                return self.get_order_dispatch_prefetch(<OrderDispatchContext>context);
            }
            "encounter-start" => {
                return self.get_encounter_start_prefetch(<EncounterStartContext>context);
            }
            "encounter-discharge" => {
                return self.get_encounter_discharge_prefetch(<EncounterDischargeContext>context);
            }
        }

        return error("Invalid hook");
    }
}
