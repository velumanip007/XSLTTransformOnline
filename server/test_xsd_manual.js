const { parentPort } = require('worker_threads');

async function testValidation() {
    try {
        console.log("Importing libxml2-wasm...");
        const libxmlModule = await import('libxml2-wasm');
        const { XmlDocument, XsdValidator } = libxmlModule;

        const xsdContent = `<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="note">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="to" type="xs:string"/>
      <xs:element name="from" type="xs:string"/>
      <xs:element name="heading" type="xs:string"/>
      <xs:element name="body" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>
</xs:schema>`;

        const xsdDoc = XmlDocument.fromString(xsdContent);
        const validator = XsdValidator.fromDoc(xsdDoc);

        // CASE 1: VALID XML
        const validXml = `<?xml version="1.0"?>
<note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>`;
        console.log("\n--- Testing VALID XML ---");
        try {
            const doc1 = XmlDocument.fromString(validXml);
            const res1 = validator.validate(doc1);
            console.log("Result:", res1);
            if (doc1.validationErrors) console.log("Doc Errors:", doc1.validationErrors);
            if (validator.validationErrors) console.log("Validator Errors:", validator.validationErrors);
            doc1.dispose();
        } catch (e) {
            console.log("Exception:", e);
        }

        // CASE 2: INVALID XML (Missing 'from' element)
        const invalidXml = `<?xml version="1.0"?>
<note>
  <to>Tove</to>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>`;
        console.log("\n--- Testing INVALID XML ---");
        try {
            const doc2 = XmlDocument.fromString(invalidXml);
            const res2 = validator.validate(doc2);
            console.log("Result:", res2);
            if (doc2.validationErrors) console.log("Doc Errors:", doc2.validationErrors);
            if (validator.validationErrors) console.log("Validator Errors:", validator.validationErrors);
            doc2.dispose();
        } catch (e) {
            console.log("Exception:", e);
        }

        xsdDoc.dispose();
        validator.dispose();

    } catch (e) {
        console.error("Test Error:", e);
    }
}

testValidation();
