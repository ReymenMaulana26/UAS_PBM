<?php 

    require "config.php";
    
    $data       = mysqli_query($con, "select * from inventory");
    $data       = mysqli_fetch_all($data, MYSQLI_ASSOC);

    echo json_encode($data);

?>

<?php 
