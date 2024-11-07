<?php
// Koneksi ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

// Periksa koneksi
if (!$conn) {
    die(json_encode(['error' => 'Gagal terhubung ke database: ' . mysqli_connect_error()]));
}

// Query untuk membaca data peminjaman
$query = mysqli_query($conn, "
    SELECT pm.Kode_pinjam, pm.kode_barang, pm.Jumlah_barang, pm.tanggal_pinjam, pm.tanggal_kembali, pm.status, 
           a.username, a.role, a.no_identitas 
    FROM peminjaman AS pm
    INNER JOIN admin AS a ON a.no_identitas = pm.no_identitas
");

if ($query) {
    $data = mysqli_fetch_all($query, MYSQLI_ASSOC);
    echo json_encode($data);
} else {
    echo json_encode(['error' => 'Gagal mengambil data peminjaman']);
}

// Tutup koneksi database
mysqli_close($conn);
?>
