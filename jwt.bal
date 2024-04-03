import ballerina/jwt;

// Create a JWT Validator with your configurations
final readonly & jwt:ValidatorConfig validatorConfig = {
    issuer: "wso2",
    audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
    clockSkew: 60,
    signatureConfig: {
        certFile: "../resource/path/to/public.crt"
    }
};

// Create a JWT Issuer with your configurations
final readonly & jwt:IssuerConfig issuerConfig = {
    username: "ballerina",
    issuer: "wso2",
    audience: "vEwzbcasJVQm1jVYHUHCjhxZ4tYa",
    expTime: 3600,
    signatureConfig: {
        config: {
            keyFile: "resource/path/to/private.key"
        }
    }
};

// Note: 
// CDS Client MUST use its private key to digitally sign the JWT
isolated function jwtAuth(string jwt_token) returns error? {
    jwt:Payload result = check jwt:validate(jwt_token, validatorConfig);
    return;
}

// Issue a JWT
isolated function issueJWT() returns string|error {
    string jwt = check jwt:issue(issuerConfig);
    return jwt;
}