type RuleRepositoryConnector object {
    isolated function appointment_book(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function patient_view(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function order_sign(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function order_select(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function order_dispatch(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function encounter_start(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function encounter_end(CdsRequest cdsRequest) returns CdsResponse|error;

    isolated function feedback(string hook, Feedback feedback);
};