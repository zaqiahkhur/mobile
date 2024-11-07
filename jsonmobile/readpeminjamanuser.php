<?php
session_start(); // Memulai sesi

// Menghubungkan ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

if (!isset($_GET['no_identitas'])) {
    echo "User tidak login.";
    exit();
}

$no_identitas = $_GET['no_identitas'];
$hasil = mysqli_query($conn, "SELECT * FROM peminjaman WHERE no_identitas = '$no_identitas'");

$rows = [];
while ($row = mysqli_fetch_assoc($hasil)) {
    $rows[] = $row;
}

echo json_encode($rows);

// Memastikan $_SESSION['no_identitas'] sudah ada
if (isset($_SESSION['no_identitas'])) {
    $data = getpinjam($_SESSION['no_identitas']);
} else {
    $data = []; // Atau beri respons jika pengguna belum login
    echo "User tidak login.";
}

// Menampilkan pengguna dengan role 'member'
$sql_users = "SELECT no_identitas, username FROM admin WHERE role = 'member'";
$result_users = mysqli_query($conn, $sql_users);

// Memastikan hasil query tidak error
if (!$result_users) {
    die("Query Error: " . mysqli_error($conn));
}

// Tutup koneksi saat selesai
mysqli_close($conn);
?>
