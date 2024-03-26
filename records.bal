import ballerinax/health.fhir.r4;

type Services record {|
    CdsService[] services;
|};

// Defines a CDS service according to the spec - https://cds-hooks.hl7.org/2.0/#discovery
type CdsService record {|
    // The hook this service should be invoked on.
    string hook;
    // The human-friendly name of this service.
    string title?;
    // The description of this service.
    string description;
    // The {id} portion of the URL to this service which is available at
    // {baseUrl }/cds -services/{id}
    string id;
    // An object containing key/value pairs of FHIR queries that this service is requesting the CDS Client to perform and provide on each 
    // service call. The key is a string that describes the type of data being requested and the value is a string representing the FHIR query.
    map<string> prefetch?;
    // Human-friendly description of any preconditions for the use of this CDS Service.
    string usageRequirements?;
|};

type Link record {|
    string label;
    string url;
    string 'type;
    string appContext?;
|};

type Coding record {|
    string system;
    string code;
    string display?;
|};

type Source record {|
    string label;
    string url?;
    string icon?;
    Coding topic?;
|};

enum Type {
    CREATE = "create",
    UPDATE = "update",
    DELETE = "delete"
};

type Action record {|
    Type 'type;
    string description;
    r4:DomainResource 'resource?;
    string resourceId?;
|};

type Suggestion record {|
    string label;
    string uuid?;
    boolean isRecommended?;
    Action[] actions?;
|};

type Card record {|
    string uuid?;
    string summary;
    string detail?;
    string indicator;
    Source 'source;
    Suggestion[] suggestions?;
    string selectionBehavior?;
    Coding[] overrideReason?;
    Link[] links?;
|};

type CdsResponse record {|
    Card[] cards;
    Action[] systemActions?;
|};

////////// Cds Request //////////
type FhirAuthorization record {|
    string access_token;
    string token_type;
    int expires_in;
    string scope;
    string subject;
    string patient?;
|};

type Appointment r4:DomainResource;

type Context record {
};

type OrderSignContext record {|
    *Context;
    string patientId;
    // The id of the current user.
    // For this hook, the user is expected to be of type Practitioner or PractitionerRole.
    // For example, PractitionerRole/123 or Practitioner/abc.
    string userId;
    string encounterId?;
    // FHIR Bundle of DeviceRequest, MedicationRequest, NutritionOrder, ServiceRequest, VisionPrescription (typically with draft status)
    r4:Bundle draftOrders;
|};

type AppointmentBookContext record {|
    *Context;
    string patientId;
    // The id of the current user.
    // For this hook, the user could be of type Practitioner, PractitionerRole, Patient, or RelatedPerson.
    // For example, PractitionerRole/123. Patient or RelatedPerson are appropriate when a patient or their proxy are booking the appointment.
    string userId;
    string encounterId?;
    // FHIR Bundle of Appointments in 'proposed' state
    r4:Bundle appointments;
|};

type CdsRequest record {|
    string hook;
    string hookInstance;
    string fhirServer?;
    FhirAuthorization fhirAuthorization?;
    Context context;
    r4:DomainResource prefetch?;
|};
