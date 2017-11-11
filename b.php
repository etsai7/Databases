<html>
    <body>
        <?php
            include 'open.php';
            $ssn = $_POST["ssn"];                                         // Get the user input.
            $mysqli->multi_query("CALL ShowPercentages('".$ssn."');");      // Execute the query with the input.
            $res = $mysqli->store_result();
            if ($res) {
                echo "<table border=\"1px solid black\">";
                echo "<tr><th> SSN </th>";
                echo "<th> Section </th>";
                echo "<th> LName </th>";
                echo "<th> FName </th>";
                echo "<th> HW1% </th>";
                echo "<th> HW2a% </th>";
                echo "<th> HW2b% </th>";
                echo "<th> Midterm% </th>";
                echo "<th> HW3% </th>";
                echo "<th> FExam% </th>";
                echo "<th> WeightedScore </th>".
                "</tr>";
                while ($row = $res->fetch_assoc()) {
                    echo "<tr><td>" . $row['SSN'] . "</td>".
                    "<td>" . $row['Section'] . "</td>".
                    "<td>" . $row['LName'] . "</td>".
                    "<td>" . $row['FName'] . "</td>".
                    "<td>" . $row['HW1%'] . "</td>".
                    "<td>" . $row['HW2a%'] . "</td>".
                    "<td>" . $row['HW2b%'] . "</td>".
                    "<td>" . $row['Midterm%'] . "</td>".
                    "<td>" . $row['HW3%'] . "</td>".
                    "<td>" . $row['FExam%'] . "</td>".
                    "<td>" . $row['WeightedScore'] . "</td>".
                    "</tr>"
                    ;          
                }   
                echo "</table>";
                $res->free();                                                               // Clean-up.
            } else {
                printf("<br>Error: %s\n", $mysqli->error);                      // The procedure failed to execute.
            }   
            $mysqli->close();                                                               // Clean-up.
        ?>  
    </body>
</html>
