<%@ page import="java.io.*, javax.xml.parsers.*, org.w3c.dom.*, javax.xml.transform.*, javax.xml.transform.dom.DOMSource, javax.xml.transform.stream.StreamResult" %>
<%
    // Define the XML file path
    String filePath = application.getRealPath("/") + "Quiz/ans.xml";

    synchronized (application) {
        try {
            // Initialize XML document builder
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc;

            // Check if ans.xml exists and load it, otherwise create a new document
            File xmlFile = new File(filePath);
            if (xmlFile.exists() && xmlFile.length() != 0) {
                doc = dBuilder.parse(xmlFile);
                doc.getDocumentElement().normalize();
            } else {
                // If the file doesn't exist, create a new root element
                doc = dBuilder.newDocument();
                Element rootElement = doc.createElement("Questions");
                doc.appendChild(rootElement);
            }

            // Iterate through the submitted form data for questions
            int questionCount = 1;
            while (request.getParameter("question_" + questionCount) != null) {
                String questionText = request.getParameter("question_" + questionCount);
                String correctAnswer = request.getParameter("correctAnswer_" + questionCount);
                String optionsCount = request.getParameter("optionsCount_" + questionCount);

                // Create a new Question element
                Element question = doc.createElement("Question");
                question.setAttribute("id", String.valueOf(questionCount));

                // Add question text
                question.appendChild(createElementWithText(doc, "Text", questionText));

                // Add options
                Element options = doc.createElement("Options");
                for (int i = 1; i <= Integer.parseInt(optionsCount); i++) {
                    String optionText = request.getParameter("option_" + questionCount + "_" + i);
                    options.appendChild(createElementWithText(doc, "Option", optionText));
                }
                question.appendChild(options);

                // Add correct answer
                question.appendChild(createElementWithText(doc, "CorrectAnswer", correctAnswer));

                // Append question to root
                doc.getDocumentElement().appendChild(question);

                questionCount++;
            }

            // Write the updated document back to the file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            StreamResult result = new StreamResult(new File(filePath));
            transformer.transform(source, result);

            // Success message
            out.println("<h2>Questions saved successfully!</h2>");
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
