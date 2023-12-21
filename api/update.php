<?php

require "config.php";

// Fungsi untuk mendapatkan ekstensi dari tipe MIME
function mime_to_ext($mime) {
    $mime_to_ext_map = array(
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        // Tambahkan tipe MIME lain jika diperlukan
    );

    return $mime_to_ext_map[$mime] ?? 'unknown';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $namaBarang = $_POST['namaBarang'];
    $jumlahBarang = $_POST['jumlahBarang'];
    $keterangan = $_POST['keterangan'];
    $id = $_POST['id'];

    if (isset($_POST['image'])) {
        $image = $_POST['image'];

        // Mengonversi base64 ke blob
        $imageBlob = base64_decode($image);

        // Mendapatkan tipe MIME dari data gambar
        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mime = $finfo->buffer($imageBlob);

        // Menentukan direktori untuk menyimpan gambar
        $uploadDir = "images/";

        // Membuat direktori jika belum ada
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Menyimpan gambar ke direktori server
        $imageName = uniqid() . "." . mime_to_ext($mime);
        $imagePath = $uploadDir . $imageName;
        file_put_contents($imagePath, $imageBlob);
    }

    $result = mysqli_query($con, "UPDATE inventory SET namaBarang='$namaBarang', jumlahBarang='$jumlahBarang', image='$imageName', keterangan='$keterangan' WHERE id='$id'");
    if ($result) {
        $response['value'] = 1;
        $response['message'] = "Berhasil ditambahkan";
        echo json_encode($response);
    } else {
        $response['value'] = 0;
        $response['message'] = "Gagal ditambahkan";
        echo json_encode($response);
    }
}
?>
