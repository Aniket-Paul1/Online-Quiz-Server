<!DOCTYPE html>
<html>
<head>
    <title>Enter Questions and Options</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 100%;
            max-width: 700px;
            overflow-y: auto;
            max-height: 90vh;
        }
        input[type="text"], input[type="number"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 16px;
        }
        input[type="submit"], button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        input[type="submit"]:hover, button:hover {
            background-color: #45a049;
        }
        .question-group, .option-group {
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 15px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        .error {
            color: red;
            font-size: 14px;
        }
    </style>
    <script>
        // Function to dynamically add option input fields
        function addOptionsFields(numOptions, questionId) {
            const optionsDiv = document.getElementById('options_' + questionId);
            optionsDiv.innerHTML = ''; // Clear previous options
            
            if (numOptions < 2) {
                const errorMsg = document.createElement('p');
                errorMsg.className = 'error';
                errorMsg.innerText = 'Please enter at least 2 options.';
                optionsDiv.appendChild(errorMsg);
                return;
            }

            for (let i = 1; i <= numOptions; i++) {
                const optionLabel = document.createElement('label');
                optionLabel.innerText = "Option " + i + ":";
                
                const optionInput = document.createElement('input');
                optionInput.type = 'text';
                optionInput.name = 'option_' + questionId + '_' + i;
                optionInput.placeholder = 'Enter option ' + i;

                optionsDiv.appendChild(optionLabel);
                optionsDiv.appendChild(optionInput);
            }
        }

        // Function to add new question block
        function addQuestion() {
            const questionsDiv = document.getElementById('questions');
            const questionCount = document.querySelectorAll('.question-group').length + 1;

            const questionDiv = document.createElement('div');
            questionDiv.classList.add('question-group');
            questionDiv.id = 'question_' + questionCount;

            // Question Text
            const questionLabel = document.createElement('label');
            questionLabel.innerText = 'Question ' + questionCount + ':';
            const questionInput = document.createElement('input');
            questionInput.type = 'text';
            questionInput.name = 'question_' + questionCount;
            questionInput.placeholder = 'Enter question text';
            questionInput.required = true;
            questionDiv.appendChild(questionLabel);
            questionDiv.appendChild(questionInput);

            // Number of Options
            const optionsCountLabel = document.createElement('label');
            optionsCountLabel.innerText = 'Number of Options:';
            const optionsCountInput = document.createElement('input');
            optionsCountInput.type = 'number';
            optionsCountInput.name = 'optionsCount_' + questionCount;
            optionsCountInput.min = '2';
            optionsCountInput.placeholder = 'Enter number of options';
            optionsCountInput.onchange = function() {
                addOptionsFields(this.value, questionCount);
            };
            questionDiv.appendChild(optionsCountLabel);
            questionDiv.appendChild(optionsCountInput);

            // Placeholder for options
            const optionsDiv = document.createElement('div');
            optionsDiv.id = 'options_' + questionCount;
            questionDiv.appendChild(optionsDiv);

            // Correct Answer
            const correctAnswerLabel = document.createElement('label');
            correctAnswerLabel.innerText = 'Correct Answer:';
            const correctAnswerInput = document.createElement('input');
            correctAnswerInput.type = 'text';
            correctAnswerInput.name = 'correctAnswer_' + questionCount;
            correctAnswerInput.placeholder = 'Enter correct answer';
            correctAnswerInput.required = true;
            questionDiv.appendChild(correctAnswerLabel);
            questionDiv.appendChild(correctAnswerInput);

            // Add this question block to the DOM
            questionsDiv.appendChild(questionDiv);
        }

        // Function to clear all questions
        function clearQuestions() {
            const questionsDiv = document.getElementById('questions');
            questionsDiv.innerHTML = ''; // Clear all questions
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Enter Questions and Options</h2>
        <form action="saveQuestions.jsp" method="post">
            <div id="questions">
                <!-- Question blocks will be dynamically added here -->
            </div>
            <button type="button" onclick="addQuestion()">Add Question</button>
            <button type="button" onclick="clearQuestions()">Clear Questions</button>
            <br><br>
            <input type="submit" value="Save Questions">
        </form>
    </div>
</body>
</html>
