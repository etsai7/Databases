<html>
    <body>
        <?php
            include 'open.php';
            $Ticker = $_POST["Ticker"]; // Get the user input.
            $mysqli->multi_query("CALL EmployeesOfCompany('".$Ticker."');");      // Execute the query with the input.
            $res = $mysqli->store_result();
            if ($res) {
                echo "<table border=\"1px solid black\">";
                echo "<tr><th> Employee Count  </th></tr>";
                while ($row = $res->fetch_assoc()) {
                    echo "<tr><td>" . $row['employees'] . "</td></tr>"
                    ;
                }
                echo "</table>";
                $res->free();  // Clean-up.
            } else {
                printf("<br>Error: %s\n", $mysqli->error);  // The procedure failed to execute.
            }   
            $mysqli->close();   // Clean-up.
        ?>  
    </body>
</html>