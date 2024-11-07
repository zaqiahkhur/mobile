<?php
$conn=mysqli_connect("localhost","root","","peminjamanbarang");


if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Query untuk mengambil no_identitas
$query = "SELECT no_identitas FROM adminx"; // Misalkan di tabel users
$result = mysqli_query($conn, $query);

$data = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
}

// Mengembalikan data dalam format JSON
echo json_encode($data);

// Tutup koneksi
mysqli_close($conn);
?>
