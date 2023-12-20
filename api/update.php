<?php

require "config.php";
$namaBarang     = $_POST['namaBarang'];
$jumlahBarang   = $_POST['jumlahBarang'];
$keterangan     = $_POST['keterangan'];
$id             = $_POST['id'];
        
$result = mysqli_query($con, "update inventory set namaBarang='$namaBarang', jumlahBarang='$jumlahBarang', keterangan='$keterangan' where id='$id'");
        
if($result){
    echo json_encode([
        'message' => 'Data edit successfully'
    ]);
}else{
    echo json_encode([
        'message' => 'Data Failed to update'
    ]);
}

?>