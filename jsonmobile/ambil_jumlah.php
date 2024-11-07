<?php
// Koneksi ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

// Fungsi untuk mendapatkan jumlah data
function total_data($query) {
    global $conn;
    $result = mysqli_query($conn, $query);
    $row = mysqli_fetch_array($result);
    return $row[0];
}

// Fungsi untuk menghitung status barang yang sudah kembali atau belum
function getCountStatus($table, $status) {
    global $conn;
    $query = "SELECT COUNT(*) FROM $table WHERE status = '$status'";
    $result = mysqli_query($conn, $query);
    $row = mysqli_fetch_array($result);
    return $row[0];
}

// Menghitung total data barang
$total_barang = total_data("SELECT COUNT(*) FROM barang");
$total_peminjaman = total_data("SELECT COUNT(*) FROM peminjaman");

// Menghitung total user dengan role member
$total_user = total_data("SELECT COUNT(*) FROM admin WHERE role = 'member'");

// Menghitung barang yang sudah kembali
$total_barang_sudah_kembali = getCountStatus("peminjaman", "kembali");

// Menghitung barang yang belum kembali
$barang_belum_kembali = getCountStatus("peminjaman", "belum kembali");

// Menyusun hasil dalam array
$result['menampilkan_asset'] = [
    "asset_barang" => $total_barang,
    "asset_peminjaman" => $total_peminjaman,
    "asset_user" => $total_user,
    "barang_sudah_kembali" => $total_barang_sudah_kembali,
    "barang_belum_kembali" => $barang_belum_kembali,
    "status" => 'request valid',
];

// Mengirimkan hasil dalam format JSON
echo json_encode($result);
?>
