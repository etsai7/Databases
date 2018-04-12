<html>
    <body>
        <?php
            include 'open.php';
            $Country = $_POST["Country"];
            $mysqli->multi_query("CALL BiggestEmployerInCountry('".$Country."');");      // Execute the query with the input.
            $res = $mysqli->store_result();
            if ($res) {
                echo "<table border=\"1px solid black\">";
                echo "<tr><th> Ticker  </th></tr>";
                while ($row = $res->fetch_assoc()) {
                    echo "<tr><td>" . $row['tick'] . "</td>"
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