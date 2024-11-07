<?php
// Koneksi ke database
$conn = mysqli_connect("localhost", "root", "", "peminjamanbarang");

// Cek koneksi
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Query untuk mendapatkan barang yang statusnya belum dikembalikan
$sql = "SELECT peminjaman.id, peminjaman.Jumlah_barang, peminjaman.keperluan, peminjaman.kode_barang,
barang.nama_barang, peminjaman.Kode_pinjam, peminjaman.no_identitas, admin.username, peminjaman.status, peminjaman.tanggal_kembali, peminjaman.tanggal_pinjam
FROM peminjaman 
INNER JOIN barang ON barang.Kode_barang = peminjaman.kode_barang 
INNER JOIN admin ON peminjaman.no_identitas = admin.no_identitas 
WHERE peminjaman.status='kembali'";

$result = mysqli_query($conn, $sql);

$barang_dikembalikan = [];

if ($result && mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_assoc($result)) {
        $barang_dikembalikan[] = [
            'nama_barang' => $row['nama_barang'] ?? 'Nama tidak tersedia',
            'kode_barang' => $row['kode_barang'] ?? 'Kode tidak tersedia',
            'no_identitas' => $row['no_identitas'] ?? 'Peminjam tidak tersedia',
            'username' => $row['username'] ?? 'Username tidak tersedia',
            'tanggal_pinjam' => $row['tanggal_pinjam'] ?? 'Tanggal pinjam tidak tersedia',
            'tanggal_kembali' => $row['tanggal_kembali'] ?? 'Tanggal kembali tidak tersedia',
            'status' => $row['status'] ?? 'Status tidak tersedia',
        ];
    }

    // Mengembalikan data dalam format JSON
    echo json_encode([
        'success' => true,
        'data' => $barang_dikembalikan,
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Tidak ada barang yang belum dikembalikan',
    ]);
}

mysqli_close($conn);
?>
