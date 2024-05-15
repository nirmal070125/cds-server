import ballerinax/health.fhir.r4;
import ballerinax/health.fhir.r4.international401;
import ballerina/jwt;
// import healthcare/crd;

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

type OverrideReason record {|
    // The Coding object representing the override reason selected by the end user. 
    // Required if user selected an override reason from the list of reasons provided in the Card (instead of only leaving a userComment).
    Coding reason?; 
    // The CDS Client may enable the clinician to further explain why the card was rejected with free text. 
    // That user comment may be communicated to the CDS Service as a userComment
    string userComment?;
|};

type AcceptedSuggestion record {|
    // The card.suggestion.uuid from the CDS Hooks response. 
    // Uniquely identifies the suggestion that was accepted.
    string id;
|};

type Feedback record {|
    // The card.uuid from the CDS Hooks response. Uniquely identifies the card.
    string card;
    // A value of accepted or overridden.
    string outcome;
    // An array of json objects identifying one or more of the user's AcceptedSuggestions. 
    // Required for accepted outcomes.
    AcceptedSuggestion[] acceptedSuggestions?;
    // A json object capturing the override reason as a Coding as well as any comments entered by the user.
    OverrideReason overrideReason?;
    // ISO8601 representation of the date and time in Coordinated Universal Time (UTC) when action was taken on the card, 
    // as profiled in section 5.6 of RFC3339. e.g. 1985-04-12T23:20:50.52Z
    string outcomeTimestamp;
|};

type Link record {|
    // Human-readable label to display for this link
    string label;
    // URL to load (via GET, in a browser context) when a user clicks on this link. 
    // Note that this MAY be a "deep link" with context embedded in path segments, query parameters, or a hash.
    string url;
    // The type of the given URL. There are two possible values for this field. 
    // A type of absolute indicates that the URL is absolute and should be treated as-is. 
    // A type of smart indicates that the URL is a SMART app launch URL and the CDS Client should ensure the SMART app launch URL is populated with the appropriate SMART launch parameters.
    string 'type;
    // An optional field that allows the CDS Service to share information from the CDS card with a subsequently launched SMART app. 
    // The appContext field should only be valued if the link type is smart and is not valid for absolute links. 
    // The appContext field and value will be sent to the SMART app as part of the OAuth 2.0 access token response, alongside the other SMART launch parameters when the SMART app is launched.
    string appContext?;
|};

type Coding record {|
    // The code for what is being represented
    string system;
    // The codesystem for this code.
    string code;
    // A short, human-readable label to display. REQUIRED for Override Reasons provided by the CDS Service, OPTIONAL for Topic.
    string display?;
|};

type Source record {|
    // A short, human-readable label to display for the source of the information displayed on this card. 
    // If a url is also specified, this MAY be the text for the hyperlink.
    string label;
    // An optional absolute URL to load (via GET, in a browser context) when a user clicks on this link to learn more about 
    // the organization or data set that provided the information on this card.
    string url?;
    // An absolute URL to an icon for the source of this card. 
    string icon?;
    // A topic describes the content of the card by providing a high-level categorization that can be useful for filtering, 
    // searching or ordered display of related cards in the CDS client's UI.
    Coding topic?;
|};

enum Type {
    CREATE = "create",
    UPDATE = "update",
    DELETE = "delete"
};

type Action record {|
    // The type of action being performed. Allowed values are: create, update, delete.
    Type 'type;
    // Human-readable description of the suggested action MAY be presented to the end-user.
    string description;
    // A FHIR resource. 
    r4:DomainResource 'resource?;
    // A relative reference to the relevant resource.
    string resourceId?;
|};

type Suggestion record {|
    // Human-readable label to display for this suggestion 
    string label;
    // Unique identifier, used for auditing and logging suggestions.
    string uuid?;
    // When there are multiple suggestions, allows a service to indicate that a specific suggestion is 
    // recommended from all the available suggestions on the card.
    boolean isRecommended?;
    // Array of objects, each defining a suggested action. Within a suggestion, all actions are logically AND'd together, 
    // such that a user selecting a suggestion selects all of the actions within it. 
    Action[] actions?;
|};

type Card record {|
    // Unique identifier of the card. 
    string uuid?;
    // One-sentence, <140-character summary message for display to the user inside of this card.
    string summary;
    // Optional detailed information to display; if provided MUST be represented in (GitHub Flavored) Markdown.
    string detail?;
    // Urgency/importance of what this card conveys. 
    // Allowed values, in order of increasing urgency, are: info, warning, critical. 
    string indicator;
    // Grouping structure for the Source of the information displayed on this card. 
    Source 'source;
    // Allows a service to suggest a set of changes in the context of the current activity
    Suggestion[] suggestions?;
    // Describes the intended selection behavior of the suggestions in the card. Allowed values are: at-most-one, any
    string selectionBehavior?;
    // Override reasons can be selected by the end user when overriding a card without taking the suggested recommendations.
    Coding[] overrideReason?;
    // Allows a service to suggest a link to an app that the user might want to run for additional information or to help guide a decision.
    Link[] links?;
|};

type CdsResponse record {|
    // Cards can provide a combination of information (for reading), suggested actions (to be applied if a user selects them), and links (to launch an app if the user selects them). 
    Card[] cards;
    // An array of Actions that the CDS Service proposes to auto-apply.
    Action[] systemActions?;
|};

////////// Cds Request //////////
public type FhirAuthorization record {|
    string access_token;
    string token_type = "Bearer";
    int expires_in;
    string scope;
    string subject;
    string patient?;
|};

type JWTPayloadHealth record {|
    *jwt:Payload;
    string tenant?;
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

type OrderSelectContext record {|
    *Context;
    string patientId;
    // The id of the current user.
    // For this hook, the user is expected to be of type Practitioner or PractitionerRole.
    // For example, PractitionerRole/123 or Practitioner/abc.
    string userId;
    string encounterId?;
    // FHIR Bundle of DeviceRequest, MedicationRequest, NutritionOrder, ServiceRequest, VisionPrescription (typically with draft status)
    r4:Bundle draftOrders;
    string[] selections;
|};

type OrderDispatchContext record {|
    *Context;
    string patientId;
    // Collection of the FHIR local references for the Request resource(s) for 
    // which fulfillment is sought E.g. ServiceRequest/123
    string[] dispatchedOrders;
    // The FHIR local reference for the Practitioner, PractitionerRole,
    // Organization, CareTeam, etc. who is being asked to execute the order. 
    // E.g. Practitioner/456
    string performer;
    // DSTU2/STU3/R4/R5 - Collection of the Task instances (as objects) that 
    // provides a full description of the fulfillment request - including the 
    // timing and any constraints on fulfillment. If Tasks are provided, each 
    // will be for a separate order and SHALL reference one of the dispatched-orders.
    string[] fulfillmentTasks;
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
    // TODO: Uncomment the following line when crd module is available
    // crd:CRDAppointment[] appointments;
    international401:Appointment[] appointments;
|};

type PatientViewContext record {|
    *Context;

    // 	The id of the current user. Must be in the format [ResourceType]/[id].
    //For this hook, the user is expected to be of type Practitioner, PractitionerRole, Patient, or RelatedPerson.
    //Patient or RelatedPerson are appropriate when a patient or their proxy are viewing the record.
    // For example, Practitioner/abc or Patient/123.
    string userId;
    // The FHIR Patient.id of the current patient in context
    string patientId;
    // The FHIR Encounter.id of the current encounter in context
    string encounterId?;
|};

type EncounterStartContext record {|
    *Context;

    // 	The id of the current user. Must be in the format [ResourceType]/[id].
    //For this hook, the user is expected to be of type Practitioner, PractitionerRole, Patient, or RelatedPerson.
    //Patient or RelatedPerson are appropriate when a patient or their proxy are viewing the record.
    // For example, Practitioner/abc or Patient/123.
    string userId;
    // The FHIR Patient.id of the current patient in context
    string patientId;
    // The FHIR Encounter.id of the current encounter in context
    string encounterId;
|};

type EncounterDischargeContext record {|
    *Context;

    // 	The id of the current user. Must be in the format [ResourceType]/[id].
    //For this hook, the user is expected to be of type Practitioner, PractitionerRole, Patient, or RelatedPerson.
    //Patient or RelatedPerson are appropriate when a patient or their proxy are viewing the record.
    // For example, Practitioner/abc or Patient/123.
    string userId;
    // The FHIR Patient.id of the current patient in context
    string patientId;
    // The FHIR Encounter.id of the current encounter in context
    string encounterId;
|};

type CdsRequest record {|
    // The hook this service should be invoked on.
    string hook;
    // 	A universally unique identifier (UUID)
    string hookInstance;
    // The base URL of the CDS Client's FHIR server.
    string fhirServer?;
    // A structure holding an OAuth 2.0 bearer access token granting the CDS Service access to FHIR resources, 
    // along with supplemental information relating to the token.
    FhirAuthorization fhirAuthorization?;
    // Hook-specific contextual data that the CDS service will need.
    Context context;
    // The FHIR data that was prefetched by the CDS Client
    map<r4:DomainResource> prefetch?;
|};
