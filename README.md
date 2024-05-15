# CDS Hooks for Davinci's CRD

# 1. Coverage Requirement Discovery

This is a ballerina template for the insurance payers who are developing the solution for the Davinci’s Coverage Requirement Discovery. 

This will contain the CDS hooks as service. The [documentation](https://build.fhir.org/ig/HL7/davinci-crd/hooks.html#hook-categories) states: “The **primary** hooks are `Appointment Book`, `Orders Sign`, and `Order Dispatch`. CRD Servers SHALL, at minimum, return a Coverage Information system action for these hooks, even if the response indicates that further information is needed or that the level of detail provided is insufficient to determine coverage. The **secondary** hooks are `Orders Select`, `Encounter Start`, and `Encounter Discharge`. These hooks MAY return cards or system actions, but are not expected to, and CRD clients are free to ignore any cards or actions returned.” 

The following features are implmented,
> 1. **CDS hooks as ballerina service**: All six hooks will be implemented as ballerina service. Since it is not mandatory to support all the hooks, the payer can implement the relevant hooks for their services. `main.bal` contains all the hooks. 
> 2. **Ballerina Records for CRD**: All of the types will be implemented as ballerina records to support type safety. `records.bal` contains the implemented records.
> 3. **Interface to connect with Rule Repository**: This interface will be defined to connect the CDS service with the CRD server (Rule repository). This will be used to process the received CDS request, prefetch the resources from the EHR repository (if needed), and construct the CDS response from the response received from the CRD server. `rule_repository_connector.bal` contains the interface to implement.
> 4. **Prefetch template class**: This class will be used to define prefetch templates, and when the context is provided, it will create a url path to access the EHR system. 
Eg: prefetch template -> "patientToGreet": `Patient/{{context.patientId}}` (The key is defined by the payer)
When the context is provided -> “patientToGreet”: “Patient/513242” (This will be replaced from the context provided in the EHR system)
> 5. **Ballerina library to support CRD resources**: This library will provide all the records for the CRD operations (CRD patient, CRD practitioner, etc). The library can be used with `import ballerinax/crd`. The following records are supported by the library. 
>> - CRDAppointment
>> - CRDCommunicationRequest
>> - CRDCoverage
>> - CRDDeviceRequest
>> - CRDDevice
>> - CRDEncounter (Versions 3.1 & 6.1)
>> - CRDLocation
>> - CRDMedicationRequest
>> - CRDNutritionOrder
>> - CRDOrganization
>> - CRDPatient
>> - CRDPractitioner
>> - CRDServiceRequest
>> - CRDTaskQuestionaire
>> - CRDVisionPrescription


The Developer needs to implement the `RuleRepositoryConnector` interface to connect with the payer side Rule Repository (CRD server). Then they can pass the relevant information from the CDS Request to the Rule repository. When the Rule Repository returns details regarding the coverage information, developer needs to implement the logic to construct the CDS response in the form of cards and System actions. 
