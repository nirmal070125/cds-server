type RuleRepositoryConnector object {

    isolated function execute(CdsRequest cdsRequest) returns CdsResponse|error;
};
