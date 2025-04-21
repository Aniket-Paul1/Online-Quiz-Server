<!DOCTYPE html>
<html>
<head>
    <title>Form Data to XML</title>
    <style>
        body {
            font-family: Arial, serif;
            background-color: #f7f7f7;
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: #fff;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 40px;
            max-width: 500px;
            width: 100%;
        }
        h2, h3 {
            text-align: center;
            color: #4CAF50;
			cursor: not-allowed;
        }
        label {
            font-size: 16px;
            color: #555;
        }
        input[type="text"], input[type="radio"] {
            margin-top: 5px;
            margin-bottom: 20px;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 15px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        input[type="submit"]:disabled {
            background-color: #ddd;
            cursor: not-allowed;
        }
        .timer {
            font-size: 20px;
            text-align: center;
            color: #FF6347;
            margin-bottom: 20px;
        }
        .time-over {
            text-align: center;
            font-size: 16px;
            color: red;
            margin-top: 20px;
        }
        .mcq-group {
            margin-bottom: 20px;
        }
        .mcq-group label {
            display: inline-block;
            font-size: 18px;
            vertical-align: left;
            margin-left: 10px;
        }
        .mcq-group input[type="radio"] {
            transform: scale(1.5);
            margin-right: 10px;
            vertical-align: left;
        }
        .mcq-group div {
			margin-top: 20px;
            margin-bottom: 10px;
        }
    </style>
    <script>
        function startTimer(duration, display) {
            var timer = duration, minutes, seconds;
            var countdown = setInterval(function() {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);
                
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                display.textContent = minutes + ":" + seconds;

                if (--timer < 0) {
                    clearInterval(countdown);
                    display.textContent = "00:00";
                    document.getElementById('submitBtn').disabled = true;
                    document.getElementById('timeOverMessage').style.display = 'block';
                }
            }, 1000);
        }
        
        window.onload = function() {
            var timeLimit = 10*60;
            var display = document.querySelector('#time');
            startTimer(timeLimit, display);

            document.getElementById("myForm").addEventListener('submit', function(e) {
                if (document.getElementById('submitBtn').disabled) {
                    e.preventDefault();
                    alert("Time is over! You cannot submit the form.");
                } else {
                    var currentTime = new Date().toLocaleString();
                    document.getElementById('submissionTime').value = currentTime;
                }
            });
        };
    </script>
</head>
<body>
    <div class="container">
        <h2>Enter Your Details</h2>

        <!-- Display timer -->
        <div class="timer">Time Left: <span id="time">10:00</span> minutes</div>

        <!-- Time over message -->
        <div id="timeOverMessage" class="time-over" style="display:none;">
            Time is over! You cannot submit the form anymore.
        </div>

        <form id="myForm" action="saveData.jsp" method="post">
            <!-- Name -->
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <!-- Department -->
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>

            <!-- Class roll number -->
            <label for="classRollNumber">Class Roll No:</label>
            <input type="text" id="classRollNumber" name="classRollNumber" required>

            <!-- MCQ Questions -->
            <h3>Multiple-Choice Questions:</h3>

            <!-- MCQ1 -->
            <div class="mcq-group">
                <label>What is the capital of India?</label>
                <div>
                    <input type="radio" id="mumbai" name="mcq1" value="Mumbai" required>
                    <label for="mumbai">Mumbai</label>
                </div>
                <div>
                    <input type="radio" id="delhi" name="mcq1" value="Delhi">
                    <label for="delhi">Delhi</label>
                </div>
                <div>
                    <input type="radio" id="kolkata" name="mcq1" value="Kolkata">
                    <label for="kolkata">Kolkata</label>
                </div>
            </div>

            <!-- MCQ2 -->
            <div class="mcq-group">
                <label>What is the name of the currency of India?</label>
                <div>
                    <input type="radio" id="dollar" name="mcq2" value="USD" required>
                    <label for="dollar">USD</label>
                </div>
                <div>
                    <input type="radio" id="rupee" name="mcq2" value="INR">
                    <label for="rupee">INR</label>
                </div>
                <div>
                    <input type="radio" id="euro" name="mcq2" value="EURO">
                    <label for="euro">EUR</label>
                </div>
            </div>

            <!-- Hidden input to store submission time -->
            <input type="hidden" id="submissionTime" name="submissionTime">

            <!-- Submit button -->
            <input type="submit" id="submitBtn" value="Submit">
        </form>
    </div>
</body>
</html>