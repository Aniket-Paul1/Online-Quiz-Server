<%@ page import="java.io.*, javax.xml.parsers.*, org.w3c.dom.*, javax.xml.transform.*, javax.xml.transform.dom.DOMSource, javax.xml.transform.stream.StreamResult" %>
<%
    // Define file paths
    String userFilePath = application.getRealPath("/") + "Quiz/userData.xml";
    String answerFilePath = application.getRealPath("/") + "Quiz/ans.xml";
    String action = request.getParameter("action");

    if ("clear".equals(action)) {
        // Clear user data
        try {
            FileWriter writer = new FileWriter(userFilePath);
            writer.write("");  // Clear the file content
            writer.close();
            out.println("<h2>All user data has been cleared.</h2>");
        } catch (IOException e) {
            e.printStackTrace();
            out.println("<h2>Error clearing user data: " + e.getMessage() + "</h2>");
        }
    } else {
        try {
            // Load user data
            File userFile = new File(userFilePath);
            if (!userFile.exists() || userFile.length() == 0) {
                out.println("<h2>No user data available.</h2>");
                return;
            }

            // Load answer key
            File answerFile = new File(answerFilePath);
            if (!answerFile.exists() || answerFile.length() == 0) {
                out.println("<h2>No answer key available.</h2>");
                return;
            }

            // Initialize XML document builder
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

            // Parse user data
            Document userDoc = dBuilder.parse(userFile);
            userDoc.getDocumentElement().normalize();
            NodeList userList = userDoc.getElementsByTagName("User");

            // Parse answer key
            Document answerDoc = dBuilder.parse(answerFile);
            answerDoc.getDocumentElement().normalize();
            NodeList questionList = answerDoc.getElementsByTagName("Question");

            // Display results
            out.println("<h2>Results</h2>");
            out.println("<table border='1'><tr><th>Name</th><th>Department</th><th>Class Roll Number</th><th>MCQ 1</th><th>MCQ 2</th><th>Submission Time</th><th>Score</th></tr>");

            // Loop through each user and calculate scores
            for (int i = 0; i < userList.getLength(); i++) {
                Node userNode = userList.item(i);
                if (userNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element userElement = (Element) userNode;

                    // Extract user details
                    String name = userElement.getElementsByTagName("Name").item(0).getTextContent();
                    String department = userElement.getElementsByTagName("Department").item(0).getTextContent();
                    String classRollNumber = userElement.getElementsByTagName("ClassRollNumber").item(0).getTextContent();
                    String mcq1 = userElement.getElementsByTagName("MCQ1").getLength() > 0 ? userElement.getElementsByTagName("MCQ1").item(0).getTextContent() : "N/A";
                    String mcq2 = userElement.getElementsByTagName("MCQ2").getLength() > 0 ? userElement.getElementsByTagName("MCQ2").item(0).getTextContent() : "N/A";
                    String submissionTime = userElement.getElementsByTagName("SubmissionTime").getLength() > 0 ? userElement.getElementsByTagName("SubmissionTime").item(0).getTextContent() : "N/A";

                    // Calculate score
                    int score = 0;
                    for (int j = 0; j < questionList.getLength(); j++) {
                        Element questionElement = (Element) questionList.item(j);
                        String correctAnswer = questionElement.getElementsByTagName("CorrectAnswer").item(0).getTextContent();
                        String userAnswer = (j == 0) ? mcq1 : mcq2;
                        if (userAnswer.equals(correctAnswer)) {
                            score++;
                        }
                    }

                    // Add Score element to the XML file
                    if (userElement.getElementsByTagName("Score").getLength() == 0) {
                        Element scoreElement = userDoc.createElement("Score");
                        scoreElement.appendChild(userDoc.createTextNode(String.valueOf(score)));
                        userElement.appendChild(scoreElement);
                    } else {
                        userElement.getElementsByTagName("Score").item(0).setTextContent(String.valueOf(score));
                    }

                    // Display user data and score
                    out.println("<tr>");
                    out.println("<td>" + name + "</td>");
                    out.println("<td>" + department + "</td>");
                    out.println("<td>" + classRollNumber + "</td>");
                    out.println("<td>" + mcq1 + "</td>");
                    out.println("<td>" + mcq2 + "</td>");
                    out.println("<td>" + submissionTime + "</td>");
                    out.println("<td>" + score + "</td>");
                    out.println("</tr>");
                }
            }

            // Write updated user data with scores to XML file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(userDoc);
            StreamResult result = new StreamResult(userFile);
            transformer.transform(source, result);

            out.println("</table>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h2>Error: " + e.getMessage() + "</h2>");
        }
    }
%>

<!-- Add Clear Database Button -->
<br>
<form method="post" action="showData.jsp">
    <input type="hidden" name="action" value="clear">
    <input type="submit" value="Clear Database">
</form>
