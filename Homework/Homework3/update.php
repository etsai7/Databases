<html>
    <body>
        <?php
            include 'open.php';
            $ssn = $_POST["ssn"];    
            $pass = $_POST["password"];  
            $score = $_POST["score"];
            $mysqli->multi_query("CALL UpdateMidterms('".$ssn."', '".$pass."', '".$score."');");
            $res = $mysqli->store_result();
            if ($res) {
              while ($row = $res->fetch_assoc()) {
                echo "<br>".$row['Result'];
              }
            }
            else {
              echo "Fail";
            }
            $mysqli->close();                                                               // Clean-up.
        ?>  
    </body>
</html>
