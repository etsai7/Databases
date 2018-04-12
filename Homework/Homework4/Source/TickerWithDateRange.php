<html>
    <body>
        <?php
            include 'open.php';
            $Ticker = $_POST["Ticker"];                                         // Get the user input.
            $date1 = $_POST["StartDate"];
            $date2 = $_POST["EndDate"];
            $mysqli->multi_query("CALL FindTickerWithDateRange('".$Ticker."','".$date1."', '".$date2."');");      // Execute the query with the input.
            $res = $mysqli->store_result();
            if ($res) {
                echo "<table border=\"1px solid black\">";
                echo "<tr><th> Ticker  </th>";
                echo "<th> Date </th>";
                echo "<th> Open Price </th>";
                echo "<th> Close Price </th>";
                echo "<th> High </th>";
                echo "<th> Low </th>";
                echo "<th> Volume </th>";
                echo "<th> Adjusted Volume </th>";
                echo "<th> Dividend </th>";
                echo "<th> Split-Ratio </th>";
                echo "<th> Adjusted Open </th>";
                echo "<th> Adjusted Close </th>";
                echo "<th> Adjusted High </th>";
                echo "<th> Adjusted Low </th></tr>";
                while ($row = $res->fetch_assoc()) {
                    echo "<tr><td>" . $row['tick'] . "</td>".
                    "<td>" . $row['date'] . "</td>".
                    "<td>" . $row['open'] . "</td>".
                    "<td>" . $row['close'] . "</td>".
                    "<td>" . $row['high'] . "</td>".
                    "<td>" . $row['low'] . "</td>".
                    "<td>" . $row['volume'] . "</td>".
                    "<td>" . $row['adjvolume'] . "</td>".
                    "<td>" . $row['div'] . "</td>".
                    "<td>" . $row['splitratio'] . "</td>".
                    "<td>" . $row['aopen'] . "</td>" .
                    "<td>" . $row['aclose'] . "</td>".
                    "<td>" . $row['ahigh'] . "</td>".
                    "<td>" . $row['alow'] . "</td>"
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