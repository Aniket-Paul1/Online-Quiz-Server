<%@ page import="java.io.*, java.util.*, javax.xml.parsers.*, org.w3c.dom.*" %>
<%
    // Get the number of top scorers to display from a request parameter, default is 5 if not provided
    int topScorersCount = 5;
    String topScorersParam = request.getParameter("topScorers");
    if (topScorersParam != null) {
        try {
            topScorersCount = Integer.parseInt(topScorersParam);
        } catch (NumberFormatException e) {
            out.println("<h2>Invalid number of top scorers. Showing default top 5.</h2>");
        }
    }

    // Define the XML file path for user data
    String filePath = application.getRealPath("/") + "Quiz/userData.xml";
    List<Map<String, String>> userList = new ArrayList<>();

    try {
        // Initialize XML document builder
        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
        File xmlFile = new File(filePath);

        if (xmlFile.exists() && xmlFile.length() != 0) {
            // Parse the XML document
            Document doc = dBuilder.parse(xmlFile);
            doc.getDocumentElement().normalize();
            NodeList userListNodes = doc.getElementsByTagName("User");

            // Loop through each user and collect their details and score
            for (int i = 0; i < userListNodes.getLength(); i++) {
                Node userNode = userListNodes.item(i);
                if (userNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element userElement = (Element) userNode;

                    // Extract user details
                    String name = userElement.getElementsByTagName("Name").item(0).getTextContent();
                    String score = userElement.getElementsByTagName("Score").item(0).getTextContent();
                    String submissionTime = userElement.getElementsByTagName("SubmissionTime").item(0).getTextContent();

                    // Store the user information in a map
                    Map<String, String> user = new HashMap<>();
                    user.put("name", name);
                    user.put("score", score);
                    user.put("submissionTime", submissionTime);
                    userList.add(user);
                }
            }

            // Sort users by score (descending) and by submission time (ascending for same scores)
            Collections.sort(userList, new Comparator<Map<String, String>>() {
                public int compare(Map<String, String> u1, Map<String, String> u2) {
                    int scoreComparison = Integer.compare(Integer.parseInt(u2.get("score")), Integer.parseInt(u1.get("score")));
                    if (scoreComparison != 0) return scoreComparison;
                    return u1.get("submissionTime").compareTo(u2.get("submissionTime"));
                }
            });

            // Display the top scorers
            out.println("<h2>Top Scorers</h2>");
            out.println("<table border='1'><tr><th>Name</th><th>Score</th><th>Submission Time</th></tr>");
            for (int i = 0; i < Math.min(topScorersCount, userList.size()); i++) {
                Map<String, String> user = userList.get(i);
                out.println("<tr>");
                out.println("<td>" + user.get("name") + "</td>");
                out.println("<td>" + user.get("score") + "</td>");
                out.println("<td>" + user.get("submissionTime") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } else {
            out.println("<h2>No user data available.</h2>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    }
%>

<!-- Form to set the number of top scorers to display -->
<form method="get" action="">
    <label for="topScorers">Number of top scorers to display:</label>
    <input type="text" id="topScorers" name="topScorers" value="<%= topScorersCount %>">
    <input type="submit" value="Show">
</form>
