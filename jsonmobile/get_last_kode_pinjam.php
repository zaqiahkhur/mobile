<?php
// Database connection
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Query untuk mengambil kode pinjam terakhir
$query = "SELECT MAX(Kode_pinjam) AS kodeTerbesar FROM peminjaman";
$result = mysqli_query($conn, $query);

$response = array();

if ($result) {
    $data2 = mysqli_fetch_array($result);
    $kodeBarangpinjam = $data2['kodeTerbesar'];

    // Mengambil nomor urutan dari kode terbesar yang ada, lalu menambahkannya
    $urutan = (int) substr($kodeBarangpinjam, 3, 3);
    $urutan++;

    // Menyusun kode baru
    $huruf = "PMJ";
    $kodeBarangpinjam = $huruf . sprintf("%03s", $urutan);

    // Menyimpan hasil dalam array response
    $response['success'] = true;
    $response['kodeBarangPinjam'] = $kodeBarangpinjam;
} else {
    $response['success'] = false;
    $response['message'] = "Error in query: " . mysqli_error($conn);
}

// Mengirimkan response dalam format JSON
echo json_encode($response);

// Close the database connection
mysqli_close($conn);
?>
