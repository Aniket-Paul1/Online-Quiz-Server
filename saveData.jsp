<%@ page import="java.io.*, javax.xml.parsers.*, org.w3c.dom.*, javax.xml.transform.*, javax.xml.transform.dom.DOMSource, javax.xml.transform.stream.StreamResult" %>
<%
    // Get form data with default values if null or empty
    String name = request.getParameter("name");
    String department = request.getParameter("department");
    String classRollNumber = request.getParameter("classRollNumber");
    String mcq1 = request.getParameter("mcq1");
    String mcq2 = request.getParameter("mcq2");
    String submissionTime = request.getParameter("submissionTime");

    // Provide default values for null or empty parameters
    name = (name == null || name.trim().isEmpty()) ? "N/A" : name;
    department = (department == null || department.trim().isEmpty()) ? "N/A" : department;
    classRollNumber = (classRollNumber == null || classRollNumber.trim().isEmpty()) ? "N/A" : classRollNumber;
    mcq1 = (mcq1 == null || mcq1.trim().isEmpty()) ? "N/A" : mcq1;
    mcq2 = (mcq2 == null || mcq2.trim().isEmpty()) ? "N/A" : mcq2;
    submissionTime = (submissionTime == null || submissionTime.trim().isEmpty()) ? "N/A" : submissionTime;

    // Define the XML file path
    String filePath = application.getRealPath("/") + "Quiz/userData.xml";

    // Synchronize to avoid race conditions
    synchronized (application) {
        try {
            // Initialize XML document builder
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc;

            // Check if file exists and load it, otherwise create a new document
            File xmlFile = new File(filePath);
            if (xmlFile.exists() && xmlFile.length() != 0) { // Ensure file is not empty
                doc = dBuilder.parse(xmlFile);
                doc.getDocumentElement().normalize();
            } else {
                // If the file doesn't exist or is empty, create a new root element
                doc = dBuilder.newDocument();
                Element rootElement = doc.createElement("Users");
                doc.appendChild(rootElement);
            }

            // Create new user element
            Element user = doc.createElement("User");

            // Create and append elements to user
            user.appendChild(createElementWithText(doc, "Name", name));
            user.appendChild(createElementWithText(doc, "Department", department));
            user.appendChild(createElementWithText(doc, "ClassRollNumber", classRollNumber));

            // Create MCQAnswers element and append answers
            Element mcqAnswers = doc.createElement("MCQAnswers");
            mcqAnswers.appendChild(createElementWithText(doc, "MCQ1", mcq1));
            mcqAnswers.appendChild(createElementWithText(doc, "MCQ2", mcq2));
            user.appendChild(mcqAnswers);

            // Create and append submission time element
            user.appendChild(createElementWithText(doc, "SubmissionTime", submissionTime));

            // Append user element to root
            doc.getDocumentElement().appendChild(user);

            // Write the content into the XML file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(xmlFile);
            transformer.transform(source, result);

            // Success message
            out.println("<center><h1>Thank You!</h1></center>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
%>

<%! 
    // Helper method to create an element with text
    private Element createElementWithText(Document doc, String tagName, String textContent) {
        Element element = doc.createElement(tagName);
        element.appendChild(doc.createTextNode(textContent));
        return element;
    }
%>